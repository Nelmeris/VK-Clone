//
//  VKService.swift
//  VK X
//
//  Created by Artem Kufaev on 09.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift
import FirebaseDatabase

class VKService {
  private init() {}
  
  static let shared = VKService()
  
  fileprivate let scheme = "https"
  fileprivate let host = "api.vk.com/method/"
  let clientId = 6472660
  let scope = 2 + 4 + 4096 + 8192 + 262144
  let apiVersion = 5.78
  
  var user: VKUserModel! {
    willSet {
      Database.database().reference().child("ids").setValue(newValue.id)
    }
  }
  
  enum requestError: Error {
    case response(String)
    case url(String)
    case accessToken(String)
    case manyRequests(String)
  }
  
  func getJSONResponse(_ response: DataResponse<Data>) throws -> JSON {
    switch response.result {
    case .success(let value):
      let json = try! JSON(data: value)
      
      guard let error = json["error"].dictionary else { return json }
      
      let error_msg = error["error_msg"]!.stringValue
      
      switch error_msg {
      case let msg where msg.contains("token") || msg.contains("access"):
        throw requestError.accessToken("REQUEST ERROR! " + error_msg)
        
      case let msg where msg.contains("many requests"):
        throw requestError.manyRequests("REQUEST ERROR! " + error_msg)
        
      default:
        throw requestError.url("REQUEST ERROR! " + error_msg)
      }
      
    case .failure(let error):
      throw requestError.response("REQUEST ERROR! " + error.localizedDescription)
    }
  }
  
  private func getRequestUrl(_ method: String, _ version: String, _ parameters: [String: String] = [: ],
                             completion: @escaping ((url: String, parameters: [String: String])) -> Void){
    let requestURL = scheme + "://" + host + method
    
    var requestParameters = parameters
    requestParameters["v"] = version
    VKTokenService.shared.getToken { token in
      requestParameters["access_token"] = token
      completion((requestURL, requestParameters))
    }
  }
  
  private func makeRequest<Response: Decodable>(_ url: String, _ parameters: [String: String], _ queue: DispatchQueue, completion: @escaping(Response) -> Void = {_ in}) {
    Alamofire.request(url, parameters: parameters).responseData(queue: queue) { response in
      do {
        _ = try self.getJSONResponse(response)
        
        let json = (try! JSON(data: response.value!))["response"]
        let data = try json.rawData()
        let model = try JSONDecoder().decode(Response.self, from: data)
        
        completion(model)
      } catch requestError.response(let error_msg) {
        print(error_msg)
      } catch requestError.url(let error_msg) {
        print(error_msg)
      } catch requestError.accessToken {
        VKTokenService.shared.tokenDelete()
        var parameters = parameters
        VKTokenService.shared.getToken { token in
          parameters["access_token"] = token
          self.makeRequest(url, parameters, queue) { (response: Response) in
            completion(response)
          }
        }
      } catch requestError.manyRequests {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) {_ in 
          self.makeRequest(url, parameters, queue) { (response: Response) in
            completion(response)
          }
        }
      } catch let error {
        print(error)
      }
    }
  }
  
  private func makeIrrevocableRequest(_ url: String, _ parameters: [String: String], _ queue: DispatchQueue, completion: @escaping() -> Void = {}) {
    Alamofire.request(url, parameters: parameters).responseData(queue: queue) { response in
      do {
        _ = try self.getJSONResponse(response)
        
        completion()
      } catch requestError.response(let error_msg) {
        print(error_msg)
      } catch requestError.url(let error_msg) {
        print(error_msg)
      } catch requestError.accessToken {
        VKTokenService.shared.tokenDelete()
        var parameters = parameters
        VKTokenService.shared.getToken { token in
          parameters["access_token"] = token
          self.makeIrrevocableRequest(url, parameters, queue) {
            completion()
          }
        }
      } catch requestError.manyRequests {
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) {_ in
          self.makeIrrevocableRequest(url, parameters, queue) {
            completion()
          }
        }
      } catch let error {
        print(error)
      }
    }
  }
  
  func request<Response: Decodable>(version: String = String(VKService.shared.apiVersion),
                                      method: String,
                                      parameters: [String: String] = [: ],
                                      queue: DispatchQueue = DispatchQueue.global(),
                                      completion: @escaping(Response) -> Void = {_ in}) {
    DispatchQueue.global().async(flags: .barrier) {
      self.getRequestUrl(method, version, parameters) { url in
        let (url, parameters) = url
        self.makeRequest(url, parameters, queue) { (response: Response) in
          completion(response)
        }
      }
    }
  }
  
  func irrevocableRequest(version: String = String(VKService.shared.apiVersion),
                                                      method: String,
                                                      parameters: [String: String] = [: ],
                                                      queue: DispatchQueue = DispatchQueue.global(),
                                                      completion: @escaping() -> Void = {}) {
    DispatchQueue.global().async(flags: .barrier) {
      self.getRequestUrl(method, version, parameters) { url in
        let (url, parameters) = url
        self.makeIrrevocableRequest(url, parameters, queue) {
          completion()
        }
      }
    }
  }
}
