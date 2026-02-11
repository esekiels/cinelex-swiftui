//
//  ApiEnvironment.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

public enum ApiEnvironment {
    
    public static var token: String {
        getValue(for: "TOKEN")
    }
    
    public static var baseUrl: String {
        getValue(for: "BASE_URL")
    }
    
    private static func getValue(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
              !value.isEmpty else {
            #if DEBUG
            return ""
            #else
            fatalError("\(key) not found or empty in .plist")
            #endif
        }
        return value
    }
}
