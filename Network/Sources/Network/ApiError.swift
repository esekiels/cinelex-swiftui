//
//  ApiError.swift
//  Network
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation
import Model
import Base

public enum ApiError: Error, LocalizedError {
    case decodingError(Error)
    case networkError(Error)
    case unauthorized(errorResponse: ErrorResponse?)
    case forbidden
    case notFound
    case timeout
    case serverError(errorResponse: ErrorResponse?)
    case unknownError(message: String?)
    
    public func value() -> AppError {
        switch self {
        case .decodingError(let error):
            return AppError(code: ErrorConstants.httpDecodingError.rawValue, description: error.localizedDescription)
        case .networkError(let error):
            return AppError(code: ErrorConstants.networkError.rawValue, description: error.localizedDescription)
        case .unauthorized(let errorResponse):
            if let message = errorResponse?.message, let code = errorResponse?.code {
                return AppError(code: String(code), description: message)
            }
            return AppError(code: ErrorConstants.httpUnauthorized.rawValue, description: "HTTPS unauthorized")
        case .forbidden:
            return AppError(code: ErrorConstants.httpForbidden.rawValue, description: "HTTPS forbidden")
        case .notFound:
            return AppError(code: ErrorConstants.httpNotFound.rawValue, description: "HTTPS not found")
        case .timeout:
            return AppError(code: ErrorConstants.httpTimeout.rawValue, description: "Server timeout")
        case .serverError(let errorResponse):
            if let message = errorResponse?.message, let code = errorResponse?.code {
                return AppError(code: String(code), description: message)
            }
            return AppError(code: ErrorConstants.httpEmptyBody.rawValue, description: "Body response not available")
        case .unknownError(let message):
            return AppError(code: ErrorConstants.unknownError.rawValue, description: message ?? "Unknown error occured")
        }
    }
}
