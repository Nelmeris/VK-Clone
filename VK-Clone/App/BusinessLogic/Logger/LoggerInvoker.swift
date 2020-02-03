//
//  LoggerInvoker.swift
//  VK-Clone
//
//  Created by Artem Kufaev on 03.02.2020.
//  Copyright © 2020 Artem Kufaev. All rights reserved.
//

import Foundation

internal final class LoggerInvoker {
    
    // MARK: Singleton
    
    internal static let shared = LoggerInvoker()
    
    // MARK: Private properties
    
    private let logger = Logger()
    
    private let batchSize = 3
    
    private var commands: [LogCommand] = []
    
    // MARK: Internal
    
    internal func addLogCommand(_ command: LogCommand) {
        self.commands.append(command)
        self.executeCommandsIfNeeded()
    }
    
    // MARK: Private
    
    private func executeCommandsIfNeeded() {
        guard self.commands.count >= batchSize else {
            return
        }
        self.commands.forEach { self.logger.writeMessageToLog($0.logMessage) }
        self.commands = []
    }
}
