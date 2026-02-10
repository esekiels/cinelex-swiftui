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
}

public final class HomeRepository: HomeRepositoryProtocol {
    
    private let dao: MovieDaoProtocol
    private let service: MovieServiceProtocol
    
    public init(dao: MovieDaoProtocol, service: MovieServiceProtocol) {
        self.dao = dao
        self.service = service
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
    
    private func fetchMovies(
        category: String,
        remoteFetch: @Sendable @escaping () async throws -> [Movie]
    ) async throws -> [Movie] {
        if let cachedItems = try? await dao.fetch(category),
           !cachedItems.isEmpty {
            
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
