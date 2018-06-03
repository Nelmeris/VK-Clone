//
//  Service.swift
//  VKService
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
    static let clientId = 6472660
    static let scope = 2 + 4 + 8192 + 262144 + 4096
    static let apiVersion = 5.78
    
    static var user: VKUserModel!
    
    static func getRequestUrl(_ method: String, _ version: String, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
        let requestURL = VKService.scheme + "://" + VKService.host + method
        
        var requestParameters = parameters
        requestParameters["access_token"] = VKTokenService.getToken()
        requestParameters["v"] = version
        
        return (requestURL, requestParameters)
    }
    
    enum RequestError: Error {
        case ResponseError(String)
        case URLError(String)
        case AccessTokenError(String)
    }
    
    static func getJSONResponse(_ response: DataResponse<Data>) throws -> JSON {
        switch response.result {
        case .success(let value):
            let json = try! JSON(data: value)
            
            if let error = json["error"].dictionary {
                let error_msg = error["error_msg"]!.stringValue
                if error_msg.range(of: "token") != nil || error_msg.range(of: "access") != nil {
                    throw RequestError.AccessTokenError(error_msg)
                } else {
                    throw RequestError.URLError(error_msg)
                }
            }
            
            return json
            
        case .failure(let error):
            throw RequestError.ResponseError(error.localizedDescription)
        }
    }
    
    static func request<Response: VKBaseModel>(version: String = String(VKService.apiVersion), method: String, parameters: [String : String] = ["" : ""], completion: @escaping(Response) -> Void = {_ in}) {
        guard let url = getRequestUrl(method, version, parameters) else { return }
        
        Alamofire.request(url.url, parameters: url.parameters).responseData(queue: DispatchQueue.global()){ response in
            do {
                let json = try getJSONResponse(response)
                
                let model = Response(json: json["response"])
                
                completion(model)
            } catch RequestError.ResponseError(let error_msg) {
                print("REQUEST ERROR! " + error_msg)
            } catch RequestError.URLError(let error_msg) {
                print("REQUEST ERROR! " + error_msg)
            } catch RequestError.AccessTokenError(let error_msg) {
                print("REQUEST ERROR! " + error_msg)
                VKTokenService.tokenReceiving()
            } catch {}
        }
        
    }
    
    static func request<Response: VKBaseModel>(url: String, completion: @escaping(Response) -> Void = {_ in}) {
        Alamofire.request(url).responseData(queue: DispatchQueue.global()) { response in
            do {
                let json = try getJSONResponse(response)
                
                let model = Response(json: json)
                
                completion(model)
            } catch {}
        }
    }
    
}
