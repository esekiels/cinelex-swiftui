//
//  CinelexLogger.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

public enum CinelexLogger {
    
    public static func debug(_ message: String) {
        #if DEBUG
        log(level: "DEBUG", message: message)
        #endif
    }
    
    public static func info(_ message: String) {
        #if DEBUG
        log(level: "INFO", message: message)
        #endif
    }
    
    public static func warning(_ message: String) {
        #if DEBUG
        log(level: "WARNING", message: message)
        #endif
    }
    
    public static func error(_ message: String) {
        #if DEBUG
        log(level: "ERROR", message: message)
        #endif
    }
    
    private static func log(level: String, message: String) {
        let timestamp = Date().formatedTimestamp()
        print("[\(timestamp)] [\(level)] \(message)")
    }
}
