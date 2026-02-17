//
//  MockSearchRepository.swift
//  Search
//
//  Created by Esekiel Surbakti on 17/02/26.
//

import Data
import Model
import Network
import Foundation

final actor MockSearchRepository: SearchRepositoryProtocol {

    private var mockMovies: [Movie] = []
    private var mockTotalPages: Int = 1
    var shouldThrowError = false

    func setMockMovies(_ movies: [Movie], totalPages: Int = 1) {
        mockMovies = movies
        mockTotalPages = totalPages
    }

    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func searchMovies(_ query: String, page: Int) async throws -> MovieResponse {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return MovieResponse(page: page, results: mockMovies, totalPages: mockTotalPages, totalResults: mockMovies.count)
    }

    func fetchRecommendations() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockMovies
    }
}
