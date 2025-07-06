//
//  NetworkManager.swift
//  Network
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation
import Alamofire
import Model

public actor NetworkManager {
    
    // MARK: - Properties
    
    public static let shared = NetworkManager()
    
    private let session: Session
    
    public init() {
        let logger = NetworkLogger()
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        session = Session(configuration: configuration, eventMonitors: [logger])
    }
    
    // MARK: - Helpers
    
    private func request<T: Decodable>(
        url: String,
        method: HTTPMethod,
        parameters: Parameters? = nil,
        token: String? = nil
    ) async throws -> T {
        let headers = buildHeaders(token: token)
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: method,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        continuation.resume(returning: decoded)
                    } catch {
                        continuation.resume(throwing: ApiError.decodingError(error))
                    }
                case .failure(let error):
                    let mappedError = self.onHttpErrorResponse(response: response, error: error)
                    continuation.resume(throwing: mappedError)
                }
            }
        }
    }
    
    private func buildHeaders(token: String?) -> HTTPHeaders {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        if let token = token {
            headers.add(name: "Authorization", value: "Bearer \(token)")
        }
        
        return headers
    }
    
    nonisolated private func onHttpErrorResponse<T>(
        response: DataResponse<T, AFError>,
        error: AFError
    ) -> ApiError {
        if let statusCode = response.response?.statusCode {
            switch statusCode {
            case 401:
                return .unauthorized(errorResponse: decodeErrorResponse(from: response.data))
            case 504:
                return .timeout
            default:
                break
            }
        }
        
        if let data = response.data {
            return .serverError(errorResponse: decodeErrorResponse(from: data))
        }
        
        if error.underlyingError is URLError {
            return .networkError(error)
        }
        
        return .unknownError(message: "")
    }
    
    nonisolated private func decodeErrorResponse(from data: Data?) -> ErrorResponse? {
        guard let data = data else {
            return nil
        }
        return try? JSONDecoder().decode(ErrorResponse.self, from: data)
    }
    
    // MARK: - Methods
    
    public func get<T: Decodable>(_ url: String, token: String? = nil) async throws -> T {
        return try await request(url: url, method: .get, token: token)
    }
}
