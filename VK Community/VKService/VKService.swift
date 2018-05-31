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
import Keychain
import RealmSwift

let VKScheme = "https"
let VKHost = "api.vk.com/method/"
var VKClientID: Int! = nil
var VKScope: Int! = nil
var VKAPIVersion: Double! = nil

// Получение нового токена
func VKTokenReceiving() {
    let storyboard = UIStoryboard(name: "VKViews", bundle: Bundle(for: VKAuthorizationUIViewController.self))
    let viewController = storyboard.instantiateViewController(withIdentifier: "VKAuthorization")
    getActiveViewController().present(viewController, animated: true, completion: nil)
}

// Проверка существования токена
func VKTokenIsExist() -> Bool {
    return Keychain.load("token") != nil
}

// Создание URL запроса
func VKRequestURL(_ method: String, _ version: String, _ parameters: [String : String] = ["" : ""]) -> (url: String, parameters: [String: String])? {
    guard VKTokenIsExist() else {
        VKTokenReceiving()
        return nil
    }
    
    let requestURL = VKScheme + "://" + VKHost + method
    
    var requestParameters = parameters
    requestParameters["access_token"] = Keychain.load("token")
    requestParameters["v"] = version
    
    return (requestURL, requestParameters)
}

enum VKRequestError: Error {
    case ResponseError(String)
    case URLError(String)
    case AccessTokenError(String)
}

// Преобразование Data в JSON
func VKGetJSONResponse(_ response: DataResponse<Data>) throws -> JSON {
    switch response.result {
    case .success(let value):
        let json = try! JSON(data: value)
        
        if let error = json["error"].dictionary {
            let error_msg = error["error_msg"]!.stringValue
            if error_msg.range(of: "token") != nil || error_msg.range(of: "access") != nil {
                throw VKRequestError.AccessTokenError(error_msg)
            } else {
                throw VKRequestError.URLError(error_msg)
            }
        }
        
        return json["response"]
        
    case .failure(let error):
        throw VKRequestError.ResponseError(error.localizedDescription)
    }
}

// Выполнение запроса
func VKRequest<Response: VKBaseModel>(version: String = String(VKAPIVersion), method: String, parameters: [String : String] = ["" : ""], completion: @escaping(Response) -> Void = {_ in}) {
    guard let url = VKRequestURL(method, version, parameters) else { return }
    
    Alamofire.request(url.url, parameters: url.parameters).responseData { response in
        do {
            let json = try VKGetJSONResponse(response)
            
            let model = Response(json: json)
            
            completion(model)
        } catch VKRequestError.ResponseError(let error_msg) {
            print("REQUEST ERROR! " + error_msg)
        } catch VKRequestError.URLError(let error_msg) {
            print("REQUEST ERROR! " + error_msg)
        } catch VKRequestError.AccessTokenError(let error_msg) {
            print("REQUEST ERROR! " + error_msg)
            VKTokenReceiving()
        } catch {}
    }
}
