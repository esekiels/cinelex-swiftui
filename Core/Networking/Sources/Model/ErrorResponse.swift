//
//  ErrorResponse.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public struct ErrorResponse: Decodable, Sendable {

    public let code: Int
    public let message: String

    enum CodingKeys: String, CodingKey {
        case code = "statusCode"
        case message = "statusMessage"
    }
}
