//
//  AuthorizationViewController.swift
//  VKService
//
//  Created by Артем on 07.05.2018.
//  Copyright © 2018 Nelmeris. All rights reserved.
//

import UIKit
import WebKit
import Keychain

class VKAuthorization: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var WebViewVK: WKWebView! {
        didSet {
            WebViewVK.navigationDelegate = self
        }
    }
    
    // Составление запроса для авторизации и вызов его в WebViewVK
    override func viewDidLoad() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: String(ClientID ?? 0)),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: String(Scope ?? 0)),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.52")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        WebViewVK.load(request)
    }
    
    // Получение адреса переадрессации
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        // Получение параметров адреса
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce ([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
        
        // Сохранение полученного токена
        _ = Keychain.save(params["access_token"]!, forKey: "token")
        
        decisionHandler(.cancel)
        
        // Возврат
        dismiss(animated: true, completion: nil)
    }
    
}
