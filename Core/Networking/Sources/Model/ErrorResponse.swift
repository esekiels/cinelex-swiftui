//
//  ErrorResponse.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public struct ErrorResponse: Decodable, Sendable {
    public let code: Int
    public let message: String
    
    public init(code: Int, message: String) {
        self.code = code
        self.message = message
    }
    
    enum CodingKeys: String, CodingKey, Sendable {
        case code = "status_code"
        case message = "status_message"
    }
}
