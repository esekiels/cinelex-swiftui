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
    func fetchNowPlaying() -> DataStream<[Movie]>
    func fetchUpcoming() -> DataStream<[Movie]>
    func fetchPopular() -> DataStream<[Movie]>
    func fetchTopRated() -> DataStream<[Movie]>
    func fetchMovieDetails(_ movieId: Int) -> DataStream<MovieDetails>
    func searchMovies(query: String, page: Int) async throws -> MoviePage
}

public final class MovieRepository: MovieRepositoryProtocol {

    private let service: MovieServiceProtocol
    private let dao: @Sendable (String) -> any MovieDaoProtocol

    public init(
        service: MovieServiceProtocol,
        dao: @Sendable @escaping (String) -> any MovieDaoProtocol = { MovieDao(category: $0) }
    ) {
        self.service = service
        self.dao = dao
    }

    public func fetchNowPlaying() -> DataStream<[Movie]> {
        fetchMovies(category: "nowPlaying", remoteFetch: service.fetchNowPlaying)
    }

    public func fetchPopular() -> DataStream<[Movie]> {
        fetchMovies(category: "popular", remoteFetch: service.fetchPopular)
    }

    public func fetchUpcoming() -> DataStream<[Movie]> {
        fetchMovies(category: "upcoming", remoteFetch: service.fetchUpcoming)
    }

    public func fetchTopRated() -> DataStream<[Movie]> {
        fetchMovies(category: "topRated", remoteFetch: service.fetchTopRated)
    }

    public func fetchMovieDetails(_ movieId: Int) -> DataStream<MovieDetails> {
        let dao = dao("")
        return .onDataStream(
            dao: { try? await dao.getDetails(movieId) },
            service: { [service] in try await service.fetchDetails(movieId) },
            then: { try await dao.saveDetails($0) }
        )
    }

    public func searchMovies(query: String, page: Int) async throws -> MoviePage {
        let response = try await service.searchMovies(query, page: page)
        return MoviePage(page: response.page, totalPages: response.totalPages, results: response.results)
    }

    private func fetchMovies(
        category: String,
        remoteFetch: @Sendable @escaping () async throws -> [Movie]
    ) -> DataStream<[Movie]> {
        let dao = dao(category)
        return .onDataStream(
            dao: {
                let items = try await dao.get()
                return items.isEmpty ? nil : items
            },
            service: remoteFetch,
            then: { try await dao.save($0) }
        )
    }
}
