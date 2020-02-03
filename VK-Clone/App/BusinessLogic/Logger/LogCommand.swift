//
//  LogCommand.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.02.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

final class LogCommand {
    
    let action: LogAction
    
    init(action: LogAction) {
        self.action = action
    }
    
    var logMessage: String {
        switch self.action {
        case .networkRequest(let query):
            return "Network request: \(query)"
        }
    }
}
