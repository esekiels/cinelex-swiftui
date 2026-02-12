//
//  MovieServiceTests.swift
//  Network
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Testing
@testable import Network
import Model
import Common

@Suite struct MovieServiceTests {
    
    private func makeSUT() -> (sut: MovieService, mock: MockApiManager) {
        let mock = MockApiManager()
        let sut = MovieService(apiManager: mock)
        return (sut, mock)
    }
    
    // MARK: - Fetch Movies
    
    static let endpoints: [(String, @Sendable (MovieService) async throws -> [Movie])] = [
        ("now_playing", { try await $0.fetchNowPlaying() }),
        ("popular", { try await $0.fetchPopular() }),
        ("top_rated", { try await $0.fetchTopRated() }),
        ("upcoming", { try await $0.fetchUpcoming() })
    ]
    
    @Test(arguments: endpoints)
    func fetchMoviesSuccess(
        endpoint: String,
        method: @Sendable (MovieService) async throws -> [Movie]
    ) async throws {
        let (sut, mock) = makeSUT()
        let expectedResponse = JsonLoader.load("NowPlayingResponse", as: MovieResponse.self)
        mock.setMockResponse(for: endpoint, response: expectedResponse)
        
        let movies = try await method(sut)
        
        #expect(mock.getCalled == true)
        #expect(movies.count == expectedResponse.results.count)
        #expect(movies[0].id == expectedResponse.results[0].id)
        #expect(movies[0].title == expectedResponse.results[0].title)
        #expect(mock.lastURL?.contains(endpoint) ?? false)
    }
    
    static let failureEndpoints: [@Sendable (MovieService) async throws -> [Movie]] = [
        { try await $0.fetchNowPlaying() },
        { try await $0.fetchPopular() },
        { try await $0.fetchTopRated() },
        { try await $0.fetchUpcoming() }
    ]
    
    @Test(arguments: failureEndpoints)
    func fetchMoviesFailure(
        method: @Sendable (MovieService) async throws -> [Movie]
    ) async {
        let (sut, mock) = makeSUT()
        mock.shouldThrowError = true
        mock.errorToThrow = CinelexApiError.unknownError(message: "Network error")
        
        await #expect(throws: CinelexApiError.self) {
            _ = try await method(sut)
        }
    }
    
    // MARK: - Fetch Details
    
    @Test func fetchDetailsSuccess() async throws {
        let (sut, mock) = makeSUT()
        let expectedResponse = JsonLoader.load("DetailsResponse", as: MovieDetails.self)
        mock.setMockResponse(for: "278", response: expectedResponse)
        
        let details = try await sut.fetchDetails(278)
        
        #expect(mock.getCalled == true)
        #expect(details.id == 278)
        #expect(details.title == "The Shawshank Redemption")
        #expect(details.genres.count == 2)
        #expect(details.credits?.cast.isEmpty == false)
        #expect(details.credits?.crew.isEmpty == false)
        #expect(details.videos?.results.isEmpty == false)
    }
    
    @Test func fetchDetailsFailure() async {
        let (sut, mock) = makeSUT()
        mock.shouldThrowError = true
        mock.errorToThrow = CinelexApiError.unknownError(message: "Network error")
        
        await #expect(throws: CinelexApiError.self) {
            _ = try await sut.fetchDetails(278)
        }
    }
}
