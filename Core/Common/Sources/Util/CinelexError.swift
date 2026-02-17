//
//  CinelexError.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public struct CinelexError: Error {
    
    public let code: String
    public let description: String
    
    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
