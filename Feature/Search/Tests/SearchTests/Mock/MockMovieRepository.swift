//
//  MockMovieRepository.swift
//  Search
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Data
import Model
import Foundation

final class MockMovieRepository: MovieRepositoryProtocol, @unchecked Sendable {

    private var mockMovies: [Movie] = []
    private var mockDetails: MovieDetails = MovieDetails.stub
    private var mockSearchTotalPages: Int = 1
    var shouldThrowError = false

    func setMockMovies(_ movies: [Movie], totalPages: Int = 1) {
        mockMovies = movies
        mockSearchTotalPages = totalPages
    }

    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func fetchNowPlaying() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchUpcoming() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchPopular() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchTopRated() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchMovieDetails(_ movieId: Int) -> AsyncStream<MovieDetails> {
        .just(mockDetails)
    }

    func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return PageResult(page: page, totalPages: mockSearchTotalPages, results: mockMovies)
    }
}
