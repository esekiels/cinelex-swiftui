//
//  ApiManager.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Common
import OSLog

public protocol ApiManagerProtocol: Sendable {
    func get<T: Decodable>(_ url: String, token: String?) async throws -> T
}

public class ApiManager: ApiManagerProtocol, @unchecked Sendable {

    public static let shared = ApiManager()

    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Cinelex",
        category: "network"
    )

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 30
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData

        self.session = URLSession(configuration: configuration)
        self.decoder = .tmdb()
    }

    public func get<T: Decodable>(_ url: String, token: String? = nil) async throws -> T {
        try await performRequest(makeRequest(url: url, token: token))
    }

    private func makeRequest(url: String, token: String?) throws -> URLRequest {
        guard let url = URL(string: url) else {
            logger.error("Invalid URL: \(url)")
            throw CinelexError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")

        if let token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        logger.info("🌐 Request \(request.httpMethod ?? "N/A") \(request.url?.absoluteString ?? "N/A")")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                logger.error("Invalid response type")
                throw CinelexError.unknownError(message: "Invalid response")
            }

            logger.debug("🌐 Response \(httpResponse.statusCode) \(httpResponse.url?.absoluteString ?? "N/A")")

            try validateResponse(httpResponse, data: data)

            return try decoder.decode(T.self, from: data)
        } catch let error as CinelexError {
            logger.error("API error: \(error.localizedDescription)")
            throw error
        } catch {
            logger.error("Decoding error: \(error.localizedDescription)")
            throw CinelexError.decodingError(error.localizedDescription)
        }
    }

    private func validateResponse(_ response: HTTPURLResponse, data: Data) throws {
        switch response.statusCode {
        case 200...299:
            return
        case 401:
            logger.warning("Unauthorized request (401)")
            throw CinelexError.unauthorized(message: parseErrorResponse(from: data)?.message)
        case 504:
            logger.warning("Request timeout (504)")
            throw CinelexError.timeout
        default:
            logger.warning("Server error: \(response.statusCode)")
            throw CinelexError.serverError(message: parseErrorResponse(from: data)?.message)
        }
    }

    private func parseErrorResponse(from data: Data) -> ErrorResponse? {
        try? decoder.decode(ErrorResponse.self, from: data)
    }
}
