//
//  MockApiManager.swift
//  Network
//
//  Created by Esekiel Surbakti on 11/02/26.
//

@testable import Network
import Common

final class MockApiManager: ApiManager, @unchecked Sendable {
    
    private(set) var getCalled = false
    private(set) var lastURL: String?
    
    var shouldThrowError = false
    var errorToThrow: Error?
    
    private var mockResponses: [String: Any] = [:]
    
    func setMockResponse(for urlPattern: String, response: Any) {
        mockResponses[urlPattern] = response
    }
    
    private func getMockResponse(for url: String) -> Any? {
        for (pattern, response) in mockResponses where url.contains(pattern) {
            return response
        }
        return nil
    }
    
    override func get<T: Decodable>(_ url: String, token: String? = nil) async throws -> T {
        getCalled = true
        lastURL = url
        
        if shouldThrowError {
            throw errorToThrow ?? CinelexApiError.unknownError(message: "Mock error")
        }
        
        guard let mockResponse = getMockResponse(for: url),
              let response = mockResponse as? T else {
            throw CinelexApiError.decodingError(NSError(domain: "MockError", code: 0))
        }
        
        return response
    }
}
