//
//  GenreServiceTests.swift
//  Network
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Testing
@testable import Network
import Model
import Common

@Suite struct GenreServiceTests {

    private func makeSUT() -> (sut: GenreServiceProtocol, mockApiManager: MockApiManager) {
        let mock = MockApiManager()
        let sut = GenreService(apiManager: mock)
        return (sut, mock)
    }
    
    @Test func fetchGenresSuccess() async throws {
        let (sut, mock) = makeSUT()
        let expectedResponse = JsonLoader.load("GenreResponse", as: GenreResponse.self)
        mock.setMockResponse(for: "genre", response: expectedResponse)
        
        let response = try await sut.fetchGenres()
        
        #expect(mock.getCalled == true)
        #expect(response.count == expectedResponse.results.count)
        #expect(response[0].id == expectedResponse.results[0].id)
        #expect(mock.lastURL?.contains("genre") ?? false)
    }
    
    @Test func fetchGenresFailed() async throws {
        let (sut, mock) = makeSUT()
        mock.shouldThrowError = true
        mock.errorToThrow = CinelexApiError.unknownError(message: "Network error")
        
        await #expect(throws: CinelexApiError.self) {
            _ = try await sut.fetchGenres()
        }
    }
}
