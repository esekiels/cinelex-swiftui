//
//  MovieRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Database
import Networking
import Model
import Common

public protocol MovieRepositoryProtocol: Sendable {
    func fetchNowPlaying() -> AsyncStream<[Movie]>
    func fetchUpcoming() -> AsyncStream<[Movie]>
    func fetchPopular() -> AsyncStream<[Movie]>
    func fetchTopRated() -> AsyncStream<[Movie]>
    func fetchMovieDetails(_ movieId: Int) -> AsyncStream<MovieDetails>
    func searchMovies(query: String, page: Int) async throws -> PageResult<Movie>
}

public final class MovieRepository: MovieRepositoryProtocol {

    private let service: MovieServiceProtocol
    private let dao: MovieDaoProtocol

    public init(service: MovieServiceProtocol, dao: MovieDaoProtocol) {
        self.service = service
        self.dao = dao
    }

    public func fetchNowPlaying() -> AsyncStream<[Movie]> {
        fetchMovies(category: "nowPlaying", remoteFetch: service.fetchNowPlaying)
    }

    public func fetchPopular() -> AsyncStream<[Movie]> {
        fetchMovies(category: "popular", remoteFetch: service.fetchPopular)
    }

    public func fetchUpcoming() -> AsyncStream<[Movie]> {
        fetchMovies(category: "upcoming", remoteFetch: service.fetchUpcoming)
    }

    public func fetchTopRated() -> AsyncStream<[Movie]> {
        fetchMovies(category: "topRated", remoteFetch: service.fetchTopRated)
    }

    public func fetchMovieDetails(_ movieId: Int) -> AsyncStream<MovieDetails> {
        .onDataStream(
            dao: { [dao] in try await dao.fetchMovieDetails(movieId) },
            service: { [service] in try await service.fetchDetails(movieId) },
            then: { [dao] in try await dao.saveMovieDetails($0) }
        )
    }

    private func fetchMovies(
        category: String,
        remoteFetch: @Sendable @escaping () async throws -> [Movie]
    ) -> AsyncStream<[Movie]> {
        .onDataStream(
            dao: { [dao] in
                let items = try await dao.fetchMoviesByCategory(category)
                return items.isEmpty ? nil : items
            },
            service: remoteFetch,
            then: { [dao] in try await dao.saveMoviesByCategory($0, category: category) }
        )
    }

    public func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        let response = try await service.searchMovies(query, page: page)
        return PageResult(page: response.page, totalPages: response.totalPages, results: response.results)
    }
}
