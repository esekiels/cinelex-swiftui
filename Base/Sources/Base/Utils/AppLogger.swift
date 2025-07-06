//
//  AppLogger.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

public enum AppLogger {
    
    public static func debug(_ message: String) {
#if DEBUG
        print("[DEBUG] \(message)")
#endif
    }
    
    public static func info(_ message: String) {
#if DEBUG
        print("[INFO] \(message)")
#endif
    }
    
    public static func warning(_ message: String) {
#if DEBUG
        print("[WARNING] \(message)")
#endif
    }
    
    public static func error(_ message: String) {
#if DEBUG
        print("[ERROR] \(message)")
#endif
    }
}
