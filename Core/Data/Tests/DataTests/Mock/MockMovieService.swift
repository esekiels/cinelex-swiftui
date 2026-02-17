//
//  MockMovieService.swift
//  Data
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Network
import Model
import Common

final actor MockMovieService: MovieServiceProtocol {
    
    private var mockMovies: [Movie] = []
    private var mockDetails: MovieDetails = MovieDetails.stub
    private var mockSearchResponse: MovieResponse = MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 0)
    var shouldThrowError = false
    var errorToThrow: Error?
    
    private(set) var fetchNowPlayingCalled = false
    private(set) var fetchPopularCalled = false
    private(set) var fetchTopRatedCalled = false
    private(set) var fetchUpcomingCalled = false
    private(set) var fetchDetailsCalled = false
    private(set) var searchMoviesCalled = false
    private(set) var lastSearchQuery: String?
    private(set) var lastSearchPage: Int?
    
    func setMockMovies(_ movies: [Movie]) {
        mockMovies = movies
    }
    
    func setMockSearchResponse(_ response: MovieResponse) {
        mockSearchResponse = response
    }
    
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }
    
    func fetchNowPlaying() async throws -> [Movie] {
        fetchNowPlayingCalled = true
        if shouldThrowError { throw errorToThrow ?? NSError(domain: "", code: 0) }
        return mockMovies
    }
    
    func fetchPopular() async throws -> [Movie] {
        fetchPopularCalled = true
        if shouldThrowError { throw errorToThrow ?? NSError(domain: "", code: 0) }
        return mockMovies
    }
    
    func fetchTopRated() async throws -> [Movie] {
        fetchTopRatedCalled = true
        if shouldThrowError { throw errorToThrow ?? NSError(domain: "", code: 0) }
        return mockMovies
    }
    
    func fetchUpcoming() async throws -> [Movie] {
        fetchUpcomingCalled = true
        if shouldThrowError { throw errorToThrow ?? NSError(domain: "", code: 0) }
        return mockMovies
    }
    
    func fetchDetails(_ movieId: Int) async throws -> MovieDetails {
        fetchDetailsCalled = true
        if shouldThrowError { throw errorToThrow ?? NSError(domain: "", code: 0) }
        return mockDetails
    }
    
    func searchMovies(_ query: String, page: Int) async throws -> MovieResponse {
        searchMoviesCalled = true
        lastSearchQuery = query
        lastSearchPage = page
        if shouldThrowError { throw errorToThrow ?? NSError(domain: "", code: 0) }
        return mockSearchResponse
    }
}
