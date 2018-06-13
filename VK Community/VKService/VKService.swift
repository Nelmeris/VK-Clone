//
//  VKService.swift
//  VK Community
//
//  Created by Артем on 09.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RealmSwift

class VKService {
    
    private init() {}
    
    static let shared = VKService()
    
    let scheme = "https"
    let host = "api.vk.com/method/"
    let clientId = 6472660 // => 6472660
    let scope = 2 + 4 + 8192 + 262144 + 4096
    let apiVersion = 5.78
    
    var user: VKUserModel!
    
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
            case let msg where msg.range(of: "token") != nil || msg.range(of: "access") != nil:
                throw requestError.accessToken("REQUEST ERROR! " + error_msg)
                
            case let msg where msg.range(of: "many requests") != nil:
                throw requestError.manyRequests("REQUEST ERROR! " + error_msg)
                
            default:
                throw requestError.url("REQUEST ERROR! " + error_msg)
            }
            
        case .failure(let error):
            throw requestError.response("REQUEST ERROR! " + error.localizedDescription)
        }
    }
    
    func getRequestUrl(_ method: String, _ version: String, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
        let requestURL = scheme + "://" + host + method
        
        var requestParameters = parameters
        requestParameters["access_token"] = VKTokenService.getToken()
        requestParameters["v"] = version
        
        return (requestURL, requestParameters)
    }
    
    func request<Response: VKBaseModel>(version: String = String(VKService.shared.apiVersion),
                                               method: String,
                                               parameters: [String : String] = ["" : ""],
                                               queue: DispatchQueue = DispatchQueue.global(),
                                               completion: @escaping(Response) -> Void = {_ in}) {
        
        queue.async {
            guard let url = self.getRequestUrl(method, version, parameters) else { return }
            
            self.makeRequest(url.url, url.parameters, queue) { (response: Response) in
                completion(response)
            }
        }
        
    }
    
    func makeRequest<Response: VKBaseModel>(_ url: String, _ parameters: [String : String], _ queue: DispatchQueue = DispatchQueue.global(), completion: @escaping(Response) -> Void = {_ in}) {
        Alamofire.request(url, parameters: parameters).responseData(queue: queue) { response in
            do {
                let json = try self.getJSONResponse(response)
                
                let model = Response(json["response"])
                
                completion(model)
            } catch requestError.response(let error_msg) {
                print(error_msg)
            } catch requestError.url(let error_msg) {
                print(error_msg)
            } catch requestError.accessToken {
                VKTokenService.tokenReceiving()
            } catch requestError.manyRequests {
                self.makeRequest(url, parameters) { (response: Response) in
                    completion(response)
                }
            } catch let error {
                print(error)
            }
        }
    }
    
}
