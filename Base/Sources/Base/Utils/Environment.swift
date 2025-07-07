//
//  Environment.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation

public enum Environment {
    
    private static func getValue(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            fatalError("\(key) not found or empty in Info.plist")
        }
        return value
    }
    
    public static let TOKEN: String = getValue(for: "TOKEN")
    
    public static let BASE_URL: String = getValue(for: "BASE_URL")
}
