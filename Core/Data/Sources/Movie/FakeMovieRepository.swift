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
    
    public func fetchNowPlaying() async throws -> [Model.Movie] {
        Movie.stubs
    }
    
    public func fetchUpcoming() async throws -> [Model.Movie] {
        Movie.stubs
    }
    
    public func fetchPopular() async throws -> [Model.Movie] {
        Movie.stubs
    }
    
    public func fetchTopRated() async throws -> [Model.Movie] {
        Movie.stubs
    }
    
    public func fetchMoveDetails(_ movieId: Int) async throws -> Model.MovieDetails {
        MovieDetails.stub
    }
    
    public func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        PageResult(page: 1, totalPages: 2, results: Movie.stubs)
    }
}
#endif
