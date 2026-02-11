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
    var shouldThrowError = false
    var errorToThrow: Error?
    
    private(set) var fetchNowPlayingCalled = false
    private(set) var fetchPopularCalled = false
    private(set) var fetchTopRatedCalled = false
    private(set) var fetchUpcomingCalled = false
    
    func setMockMovies(_ movies: [Movie]) {
        mockMovies = movies
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
}
