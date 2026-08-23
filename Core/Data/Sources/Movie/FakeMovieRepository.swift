//
//  FakeMovieRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Common
import Model

#if DEBUG
public final class FakeMovieRepository: MovieRepositoryProtocol, @unchecked Sendable {

    public var movies: [Movie]
    public var details: MovieDetails
    public var totalPages: Int
    public var error: CinelexError?

    public var errorAfterSuccess = false

    public init(
        movies: [Movie] = Movie.stubs,
        details: MovieDetails = .stub,
        totalPages: Int = 2
    ) {
        self.movies = movies
        self.details = details
        self.totalPages = totalPages
    }

    public func fetchNowPlaying() -> DataStream<[Movie]> {
        stream(movies)
    }

    public func fetchUpcoming() -> DataStream<[Movie]> {
        stream(movies)
    }

    public func fetchPopular() -> DataStream<[Movie]> {
        stream(movies)
    }

    public func fetchTopRated() -> DataStream<[Movie]> {
        stream(movies)
    }

    public func fetchMovieDetails(_ movieId: Int) -> DataStream<MovieDetails> {
        stream(details)
    }

    public func searchMovies(query: String, page: Int) async throws -> MoviePage {
        if let error {
            throw error
        }
        return MoviePage(page: page, totalPages: totalPages, results: movies)
    }

    private func stream<Value: Sendable>(_ value: Value) -> DataStream<Value> {
        guard let error else {
            return .just(value)
        }
        let yieldsCached = errorAfterSuccess
        return AsyncStream { continuation in
            if yieldsCached {
                continuation.yield(.success(value))
            }
            continuation.yield(.failure(error))
            continuation.finish()
        }
    }
}
#endif
