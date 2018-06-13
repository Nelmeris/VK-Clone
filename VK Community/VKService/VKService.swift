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
    
    static let scheme = "https"
    static let host = "api.vk.com/method/"
    static let clientId = 6472660 // => 6472660
    static let scope = 2 + 4 + 8192 + 262144 + 4096
    static let apiVersion = 5.78
    
    static var user: VKUserModel!
    
    enum requestError: Error {
        case response(String)
        case url(String)
        case accessToken(String)
        case manyRequests(String)
    }
    
    static func getJSONResponse(_ response: DataResponse<Data>) throws -> JSON {
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
    
    static func getRequestUrl(_ method: String, _ version: String, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
        let requestURL = VKService.scheme + "://" + VKService.host + method
        
        var requestParameters = parameters
        requestParameters["access_token"] = VKTokenService.getToken()
        requestParameters["v"] = version
        
        return (requestURL, requestParameters)
    }
    
    static func request<Response: VKBaseModel>(version: String = String(VKService.apiVersion),
                                               method: String,
                                               parameters: [String : String] = ["" : ""],
                                               queue: DispatchQueue = DispatchQueue.global(),
                                               completion: @escaping(Response) -> Void = {_ in}) {
        
        queue.async {
            guard let url = getRequestUrl(method, version, parameters) else { return }
            
            VKService.makeRequest(url.url, url.parameters, queue) { (response: Response) in
                completion(response)
            }
        }
        
    }
    
    static func makeRequest<Response: VKBaseModel>(_ url: String, _ parameters: [String : String], _ queue: DispatchQueue = DispatchQueue.global(), completion: @escaping(Response) -> Void = {_ in}) {
        Alamofire.request(url, parameters: parameters).responseData(queue: queue) { response in
            do {
                let json = try getJSONResponse(response)
                
                let model = Response(json["response"])
                
                completion(model)
            } catch requestError.response(let error_msg) {
                print(error_msg)
            } catch requestError.url(let error_msg) {
                print(error_msg)
            } catch requestError.accessToken {
                VKTokenService.tokenReceiving()
            } catch requestError.manyRequests {
                makeRequest(url, parameters) { (response: Response) in
                    completion(response)
                }
            } catch {}
        }
    }
    
}
