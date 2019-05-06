//
//  VKAuthorizationViewController.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 07.05.2018.
//  Copyright © 2018 Artem Kufaev. All rights reserved.
//

import UIKit
import WebKit
import Keychain

class VKAuthorizationViewController: UIViewController, WKNavigationDelegate {
    
    var WebViewVK: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WebViewVK = WKWebView(frame: self.view.frame)
        WebViewVK.navigationDelegate = self
        self.view.addSubview(WebViewVK)
        
        let request = URLRequest(url: getVKAuthorizationURL())
        
        WebViewVK.load(request)
    }
    
    func getVKAuthorizationURL() -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: String(VKService.shared.clientId)),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_url", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: String(VKService.shared.scope)),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: String(VKService.shared.apiVersion))
        ]
        
        return urlComponents.url!
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url, url.path == "/blank.html", let fragment = url.fragment else {
            decisionHandler(.allow)
            return
        }
        
        let params = getParams(fragment)
        
        let tokenValue = params["access_token"]!
        _ = Keychain.save(tokenValue, forKey: VKTokenService.shared.tokenKey)
        
        let tokenDateExpires = Date(timeIntervalSinceNow: TimeInterval(Int(params["expires_in"]!)!))
        _ = Keychain.save(String(tokenDateExpires.timeIntervalSince1970), forKey: VKTokenService.shared.tokenExpiresTimeKey)
        
        let token = VKToken(value: tokenValue, dateExpires: tokenDateExpires)
        
        decisionHandler(.cancel)
        dismiss(animated: true) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: VKTokenService.shared.notificationKey), object: token)
        }
    }
    
    func getParams(_ fragment: String) -> [String: String] {
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce ([String: String]()) { result, param in
                var dict = result
                let key = param.first!
                let value = param[1]
                dict[key] = value
                return dict
        }
        return params
    }
}
