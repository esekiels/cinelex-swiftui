//
//  ApiManager.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Common

public class ApiManager: @unchecked Sendable {
    
    public static let shared = ApiManager()
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        
        self.session = URLSession(configuration: configuration)
        self.decoder = JSONDecoder()
    }
    
    func get<T: Decodable>(_ url: String, token: String? = nil) async throws -> T {
        let request = try createRequest(url: url, method: "GET", token: token)
        return try await performRequest(request)
    }
    
    private func createRequest(
        url: String,
        method: String,
        parameters: [String: Any]? = nil,
        token: String? = nil
    ) throws -> URLRequest {
        guard let url = URL(string: url) else {
            CinelexLogger.error("Invalid URL: \(url)")
            throw CinelexApiError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        if let token = token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = parameters, method != "GET" {
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return request
    }
    
    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        logRequest(request)
        
        do {
            let (data, response) = try await session.data(for: request)
            
            logResponse(data: data, response: response)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                CinelexLogger.error("Invalid response type")
                throw CinelexApiError.unknownError(message: "Invalid response")
            }
            
            try validateResponse(httpResponse, data: data)
            
            return try decoder.decode(T.self, from: data)
        } catch let error as CinelexApiError {
            CinelexLogger.error("API Error: \(error)")
            throw error
        } catch {
            CinelexLogger.error("Decoding error: \(error.localizedDescription)")
            throw CinelexApiError.decodingError(error)
        }
    }
    
    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            CinelexLogger.warning("Unauthorized request (401)")
            let errorResponse = parseErrorResponse(from: data)
            throw CinelexApiError.unauthorized(code: errorResponse?.code, message: errorResponse?.message)
        case 504:
            CinelexLogger.warning("Request timeout (504)")
            throw CinelexApiError.timeout
        default:
            CinelexLogger.warning("Server error: \(response.statusCode)")
            let errorResponse = parseErrorResponse(from: data)
            throw CinelexApiError.serverError(code: errorResponse?.code, message: errorResponse?.message)
        }
    }
    
    private func parseErrorResponse(from data: Data?) -> ErrorResponse? {
        guard let data = data else {
            return nil
        }
        return try? decoder.decode(ErrorResponse.self, from: data)
    }
    
    private func logRequest(_ request: URLRequest) {
        CinelexLogger.info("🌐 API Request")
        CinelexLogger.debug("URL: \(request.url?.absoluteString ?? "N/A")")
        CinelexLogger.debug("Method: \(request.httpMethod ?? "N/A")")
        
        if let headers = request.allHTTPHeaderFields {
            CinelexLogger.debug("Headers: \(headers)")
        }
        
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            CinelexLogger.debug("Body: \(bodyString)")
        }
    }
    
    private func logResponse(data: Data, response: URLResponse) {
        CinelexLogger.info("🌐 API Response")
        
        if let httpResponse = response as? HTTPURLResponse {
            CinelexLogger.debug("Status: \(httpResponse.statusCode)")
            CinelexLogger.debug("URL: \(httpResponse.url?.absoluteString ?? "N/A")")
        }
        
        if let responseString = String(data: data, encoding: .utf8) {
            CinelexLogger.debug("Data: \(responseString)")
        }
    }
}
