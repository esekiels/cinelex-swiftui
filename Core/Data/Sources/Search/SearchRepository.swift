//
//  SearchRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Network
import Database
import Model

public protocol SearchRepositoryProtocol: Sendable {
    
    func fetchRecommendations() async throws -> [Movie]
    func searchMovies(_ query: String, page: Int) async throws -> MovieResponse
}

public final class SearchRepository: SearchRepositoryProtocol {
    
    private let service: MovieServiceProtocol
    private let genreDao: GenreDaoProtocol
    private let movieDao: MovieDaoProtocol
    
    public init(service: MovieServiceProtocol, genreDao: GenreDaoProtocol, movieDao: MovieDaoProtocol) {
        self.service = service
        self.genreDao = genreDao
        self.movieDao = movieDao
    }
    
    public func searchMovies(_ query: String, page: Int) async throws -> MovieResponse {
        var response = try await service.searchMovies(query, page: page)
        let genres = try await genreDao.fetch()

        response.results = response.results.map { movie in
            var movie = movie
            movie.genres = genres.filter { movie.genreIds?.contains($0.id) == true }
            return movie
        }

        return response
    }
    
    public func fetchRecommendations() async throws -> [Movie] {
        return try await movieDao.fetch("popular")
    }
}
