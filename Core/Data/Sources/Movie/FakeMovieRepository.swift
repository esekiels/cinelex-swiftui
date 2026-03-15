//
//  FakeMovieRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Model

#if DEBUG
public final class FakeMovieRepository: MovieRepositoryProtocol {

    public init() {}

    public func fetchNowPlaying() -> AsyncStream<[Movie]> {
        .just(Movie.stubs)
    }

    public func fetchUpcoming() -> AsyncStream<[Movie]> {
        .just(Movie.stubs)
    }

    public func fetchPopular() -> AsyncStream<[Movie]> {
        .just(Movie.stubs)
    }

    public func fetchTopRated() -> AsyncStream<[Movie]> {
        .just(Movie.stubs)
    }

    public func fetchMovieDetails(_ movieId: Int) -> AsyncStream<MovieDetails> {
        .just(MovieDetails.stub)
    }

    public func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        PageResult(page: 1, totalPages: 2, results: Movie.stubs)
    }
}
#endif
