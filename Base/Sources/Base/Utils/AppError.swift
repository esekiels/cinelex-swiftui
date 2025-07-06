//
//  LocalError.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

public struct AppError: Sendable, Error {
    
    public var code: String
    public var description: String
    
    public init(code: String, description: String) {
        self.code = code
        self.description = description
    }
}
