//
//  Logger.swift
//  ProximityAlarm
//
//  Created by Manuel Olmos Gil on 30/06/2019.
//  Copyright © 2019 Manuel Olmos Gil. All rights reserved.
//

import UIKit
import XCGLogger

class Logger: NSObject {

    let log = XCGLogger(identifier: "advancedLogger", includeDefaultDestinations: false)
    var loggingFileUrl: URL!

    static let shared = Logger()

    private override init() {
        // Create a destination for the system console log (via NSLog)
        let systemDestination = AppleSystemLogDestination(identifier: "advancedLogger.systemDestination")
        // Optionally set some configuration options
        systemDestination.outputLevel = .debug
        systemDestination.showLogIdentifier = false
        systemDestination.showFunctionName = true
        systemDestination.showThreadName = true
        systemDestination.showLevel = true
        systemDestination.showFileName = true
        systemDestination.showLineNumber = true
        systemDestination.showDate = true
        // Add the destination to the logger
        log.add(destination: systemDestination)
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            loggingFileUrl = dir.appendingPathComponent("logging.txt")
            // Create a file log destination
            let fileDestination = FileDestination(writeToFile: loggingFileUrl!, identifier: "advancedLogger.fileDestination", shouldAppend: true, appendMarker: "-- Relauched App --")
            // Optionally set some configuration options
            fileDestination.outputLevel = .debug
            fileDestination.showLogIdentifier = false
            fileDestination.showFunctionName = true
            fileDestination.showThreadName = true
            fileDestination.showLevel = true
            fileDestination.showFileName = true
            fileDestination.showLineNumber = true
            fileDestination.showDate = true
            // Process this destination in the background
            fileDestination.logQueue = XCGLogger.logQueue
            // Add the destination to the logger
            log.add(destination: fileDestination)
        }
        // Add basic app info, version info etc, to the start of the logs
        log.logAppDetails()
    }
}
