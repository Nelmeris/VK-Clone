//
//  VKAuthorization.swift
//  VK Community
//
//  Created by Артем on 07.05.2018.
//  Copyright © 2018 NONE. All rights reserved.
//

import UIKit
import WebKit

extension VKService {
    class VKAuthorization: UIViewController, WKNavigationDelegate {
        
        @IBOutlet weak var WebViewVK: WKWebView! {
            didSet {
                WebViewVK.navigationDelegate = self
            }
        }
        
        override func viewDidLoad() {
            var urlComponents = URLComponents()
            urlComponents.scheme = "https"
            urlComponents.host = "oauth.vk.com"
            urlComponents.path = "/authorize"
            urlComponents.queryItems = [
                URLQueryItem(name: "client_id", value: "6472660"),
                URLQueryItem(name: "display", value: "mobile"),
                URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
                URLQueryItem(name: "scope", value: "262150"),
                URLQueryItem(name: "response_type", value: "token"),
                URLQueryItem(name: "v", value: "5.52")
            ]
            
            let request = URLRequest(url: urlComponents.url!)
            
            WebViewVK.load(request)
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
            guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
                decisionHandler(.allow)
                return
            }
            
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
            
            UserDefaults.standard.setValue(params["access_token"], forKey: "token")
            UserDefaults.standard.setValue(NSDate(), forKey: "tokenDate")
            
            decisionHandler(.cancel)
            
            dismiss(animated: true, completion: nil)
        }
        
    }
}
