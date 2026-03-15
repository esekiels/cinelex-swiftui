//
//  MockMovieService.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Networking
import Model
import Foundation

final actor MockMovieService: MovieServiceProtocol {

    private var mockMovies: [Movie] = []
    private var mockDetails: MovieDetails = MovieDetails.stub
    private var mockSearchResponse: MovieResponse = MovieResponse(page: 1, results: [], totalPages: 1, totalResults: 0)
    var shouldThrowError = false

    func setMockMovies(_ movies: [Movie]) {
        mockMovies = movies
    }

    func setMockDetails(_ details: MovieDetails) {
        mockDetails = details
    }

    func setMockSearchResponse(_ response: MovieResponse) {
        mockSearchResponse = response
    }

    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func fetchNowPlaying() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }

    func fetchUpcoming() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }

    func fetchTopRated() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }

    func fetchPopular() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockMovies
    }

    func fetchDetails(_ movieId: Int) async throws -> MovieDetails {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockDetails
    }

    func searchMovies(_ query: String, page: Int) async throws -> MovieResponse {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockSearchResponse
    }
}
