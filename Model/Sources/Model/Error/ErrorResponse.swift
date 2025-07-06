//
//  ErrorResponse.swift
//  Model
//
//  Created by Esekiel Surbakti on 06/07/25.
//

public struct ErrorResponse: Decodable, Sendable {
    public let code: Int
    public let message: String
    
    enum CodingKeys: String, CodingKey {
        case code = "status_code"
        case message = "status_message"
    }
}
