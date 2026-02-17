//
//  CinelexApiError.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public enum CinelexApiError: Error {
    case invalidURL
    case decodingError(Error)
    case networkError(Error)
    case unauthorized(code: Int?, message: String?)
    case forbidden
    case notFound
    case timeout
    case serverError(code: Int?, message: String?)
    case unknownError(message: String?)
    
    // MARK: - Computed Properties
    
    public var errorCode: String {
        switch self {
        case .invalidURL:
            ErrorConstant.invalidURL
        case .decodingError:
            ErrorConstant.httpDecodingError
        case .networkError:
            ErrorConstant.networkError
        case .unauthorized(let code, _):
            if let code { String(code) } else { ErrorConstant.httpUnauthorized }
        case .forbidden:
            ErrorConstant.httpForbidden
        case .notFound:
            ErrorConstant.httpNotFound
        case .timeout:
            ErrorConstant.httpTimeout
        case .serverError(let code, _):
            if let code { String(code) } else { ErrorConstant.httpEmptyBody }
        case .unknownError:
            ErrorConstant.unknownError
        }
    }
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            "Invalid URL"
        case .decodingError(let error):
            error.localizedDescription
        case .networkError(let error):
            error.localizedDescription
        case .unauthorized(_, let message):
            message ?? "HTTPS unauthorized"
        case .forbidden:
            "HTTPS forbidden"
        case .notFound:
            "HTTPS not found"
        case .timeout:
            "Server timeout"
        case .serverError(_, let message):
            message ?? "Response body not available"
        case .unknownError(let message):
            message ?? "Unknown error occurred"
        }
    }
    
    // MARK: - Methods
    
    public func value() -> CinelexError {
        CinelexError(code: errorCode, description: errorDescription ?? "Unknown error")
    }
}
