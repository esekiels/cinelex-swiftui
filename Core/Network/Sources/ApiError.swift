//
//  ApiError.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation
import Common

public enum ApiError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
    case unauthorized(errorResponse: ErrorResponse?)
    case forbidden
    case notFound
    case timeout
    case serverError(errorResponse: ErrorResponse?)
    case unknownError(message: String?)
    
    // MARK: - Computed Properties
    
    public var errorCode: String {
        switch self {
        case .invalidURL:
            return ErrorConstant.invalidURL
        case .decodingError:
            return ErrorConstant.httpDecodingError
        case .networkError:
            return ErrorConstant.networkError
        case .unauthorized(let errorResponse):
            if let code = errorResponse?.code {
                return String(code)
            }
            return ErrorConstant.httpUnauthorized
        case .forbidden:
            return ErrorConstant.httpForbidden
        case .notFound:
            return ErrorConstant.httpNotFound
        case .timeout:
            return ErrorConstant.httpTimeout
        case .serverError(let errorResponse):
            if let code = errorResponse?.code {
                return String(code)
            }
            return ErrorConstant.httpEmptyBody
        case .unknownError:
            return ErrorConstant.unknownError
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .decodingError(let error):
            return error.localizedDescription
        case .networkError(let error):
            return error.localizedDescription
        case .unauthorized(let errorResponse):
            if let message = errorResponse?.message {
                return message
            }
            return "HTTPS unauthorized"
        case .forbidden:
            return "HTTPS forbidden"
        case .notFound:
            return "HTTPS not found"
        case .timeout:
            return "Server timeout"
        case .serverError(let errorResponse):
            if let message = errorResponse?.message {
                return message
            }
            return "Response body not available"
        case .unknownError(let message):
            return message ?? "Unknown error occurred"
        }
    }
    
    // MARK: - Methods
    
    public func value() -> CinelexError {
        return CinelexError(code: errorCode, description: errorDescription ?? "Unknown error")
    }
}
