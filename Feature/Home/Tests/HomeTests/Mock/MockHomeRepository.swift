//
//  MockHomeRepository.swift
//  Home
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Model
import Data
import Common

final actor MockHomeRepository: HomeRepositoryProtocol {
    
    private var mockMovies: [Movie] = []
    private var shouldThrowError = false
    
    func setMockMovies(_ movies: [Movie]) {
        mockMovies = movies
    }
    
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }
    
    func fetchNowPlaying() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }
    
    func fetchPopular() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }
    
    func fetchTopRated() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }
    
    func fetchUpcoming() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }
}
