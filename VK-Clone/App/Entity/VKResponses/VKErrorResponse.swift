//
//  VKErrorResponse.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 05/05/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation

enum VKErrorResponses: Error, LocalizedError {
    case vkError(response: VKErrorResponse)
    
    public var errorDescription: String? {
        switch self {
        case .vkError(let response):
            var str = "VK request error (code: \(response.code)). " + response.message
            for element in response.requestParams {
                str += "\n- \(element.key) = \(element.value)"
            }
            return NSLocalizedString(str, comment: "")
        }
    }
}

struct VKErrorResponse: Decodable {
    let message: String
    let code: Int
    let requestParams: [VKErrorRequestParam]
    
    enum CodingKeys: String, CodingKey {
        case message = "error_msg"
        case code = "error_code"
        case requestParams = "request_params"
    }
}

struct VKErrorRequestParam: Decodable {
    let key: String
    let value: String
}
