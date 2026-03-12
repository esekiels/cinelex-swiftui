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
    func fetchNowPlaying() async throws -> [Movie]
    func fetchUpcoming() async throws -> [Movie]
    func fetchPopular() async throws -> [Movie]
    func fetchTopRated() async throws -> [Movie]
    func fetchMoveDetails(_ movieId: Int) async throws -> MovieDetails
    func searchMovies(query: String, page: Int) async throws -> PageResult<Movie>
}

public final class MovieRepository: MovieRepositoryProtocol {
    
    private let service: MovieServiceProtocol
    private let dao: MovieDaoProtocol
    
    public init(service: MovieServiceProtocol, dao: MovieDaoProtocol) {
        self.service = service
        self.dao = dao
    }
    
    public func fetchNowPlaying() async throws -> [Movie] {
        try await fetchMovies(category: "nowPlaying", remoteFetch: service.fetchNowPlaying)
    }
    
    public func fetchPopular() async throws -> [Movie] {
        try await fetchMovies(category: "popular", remoteFetch: service.fetchPopular)
    }
    
    public func fetchUpcoming() async throws -> [Movie] {
        try await fetchMovies(category: "upcoming", remoteFetch: service.fetchUpcoming)
    }
    
    public func fetchTopRated() async throws -> [Movie] {
        try await fetchMovies(category: "topRated", remoteFetch: service.fetchTopRated)
    }
    
    public func fetchMoveDetails(_ movieId: Int) async throws -> MovieDetails {
        do {
            let details = try await service.fetchDetails(movieId)
            try? await dao.saveMovieDetails(details)
            return details
        } catch {
            if let cached = try? await dao.fetchMovieDetails(movieId) {
                return cached
            }
            throw error
        }
    }
    
    private func fetchMovies(
        category: String,
        remoteFetch: @Sendable @escaping () async throws -> [Movie]
    ) async throws -> [Movie] {
        if let cachedItems = try? await dao.fetchMoviesByCategory(category),
           !cachedItems.isEmpty {
            Task {
                let movies = try await remoteFetch()
                try await dao.saveMoviesByCategory(movies, category: category)
            }
            
            return cachedItems
        }
        
        let movies = try await remoteFetch()
        
        Task {
            try? await dao.saveMoviesByCategory(movies, category: category)
        }
        
        return movies
    }
    
    public func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        let response = try await service.searchMovies(query, page: page)
        return PageResult(page: response.page, totalPages: response.totalPages, results: response.results)
    }
}
