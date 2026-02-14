//
//  HomeRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Database
import Network
import Model
import Common

public protocol HomeRepositoryProtocol: Sendable {
    func fetchNowPlaying() async throws -> [Movie]
    func fetchUpcoming() async throws -> [Movie]
    func fetchPopular() async throws -> [Movie]
    func fetchTopRated() async throws -> [Movie]
    func fetchGenres() async
}

public final class HomeRepository: HomeRepositoryProtocol {
    
    private let service: MovieServiceProtocol
    private let genreService: GenreServiceProtocol
    private let dao: MovieDaoProtocol
    private let genreDao: GenreDaoProtocol
    
    public init(
        service: MovieServiceProtocol,
        genreService: GenreServiceProtocol,
        dao: MovieDaoProtocol,
        genreDao: GenreDaoProtocol) {
            self.service = service
            self.genreService = genreService
            self.dao = dao
            self.genreDao = genreDao
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
    
    public func fetchGenres() async {
        do {
            let genres = try await genreService.fetchGenres()
            try await genreDao.save(genres)
            CinelexLogger.debug("Saved \(genres.count) genres")
        } catch {
            CinelexLogger.error("Failed genres: \(error)")
        }
    }
    
    private func fetchMovies(
        category: String,
        remoteFetch: @Sendable @escaping () async throws -> [Movie]
    ) async throws -> [Movie] {
        if let cachedItems = try? await dao.fetch(category),
           !cachedItems.isEmpty {
            CinelexLogger.debug("Cache hit for \(category): \(cachedItems.count) items")
            Task {
                await refreshCache(category: category, remoteFetch: remoteFetch)
            }
            
            return cachedItems
        }
        
        let movies = try await remoteFetch()
        
        Task {
            try? await dao.save(movies, category: category)
        }
        
        return movies
    }
    
    private func refreshCache(
        category: String,
        remoteFetch: @Sendable @escaping () async throws -> [Movie]
    ) async {
        do {
            let movies = try await remoteFetch()
            try await dao.save(movies, category: category)
        } catch {
            CinelexLogger.error("Failed to refresh cache for \(category): \(error)")
        }
    }
}
