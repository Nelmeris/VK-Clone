//
//  ErrorParser.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 23/04/2019.
//  Copyright © 2019 Artem Kufaev. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorParser: AbstractErrorParser {
    func parse(_ result: Error) -> Error {
        return result
    }

    func parse(response: HTTPURLResponse?, data: Data?, error: Error?) -> Error? {
        if let data = data,
            let json = try? JSON(data: data),
            json["error"].exists() {
            let error = try! JSONDecoder().decode(VKErrorResponse.self, from: try json["error"].rawData())
            return VKErrorResponses.vkError(response: error)
        }
        return error
    }
}
