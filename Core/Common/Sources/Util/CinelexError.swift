//
//  CinelexError.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

public enum CinelexError: Error, Equatable, LocalizedError {
    case invalidURL
    case decodingError(String)
    case networkError(String)
    case unauthorized(message: String?)
    case forbidden
    case notFound
    case timeout
    case serverError(message: String?)
    case unknownError(message: String?)

    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .decodingError(let message):
            message
        case .networkError(let message):
            message
        case .unauthorized(let message):
            message ?? "HTTPS unauthorized"
        case .forbidden:
            "HTTPS forbidden"
        case .notFound:
            "HTTPS not found"
        case .timeout:
            "Server timeout"
        case .serverError(let message):
            message ?? "Response body not available"
        case .unknownError(let message):
            message ?? "Unknown error occurred"
        }
    }
}

public extension Error {

    func toCinelexError() -> CinelexError {
        (self as? CinelexError) ?? .unknownError(message: localizedDescription)
    }
}
