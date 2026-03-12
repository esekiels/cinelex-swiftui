//
//  MovieDao.swift
//  Database
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation
import Model

public protocol MovieDaoProtocol: Sendable {
    func fetchMoviesByCategory(_ category: String) async throws -> [Movie]
    func saveMoviesByCategory(_ data: [Movie], category: String) async throws
    func clearAllMovies() async throws
    func fetchMovieDetails(_ movieId: Int) async throws -> MovieDetails?
    func saveMovieDetails(_ data: MovieDetails) async throws
}

public actor MovieDao: MovieDaoProtocol {
    
    private let container: ModelContainer
    private let modelContext: ModelContext
    
    public init(container: ModelContainer = DatabaseManager.shared.container) {
        self.container = container
        self.modelContext = ModelContext(container)
    }
    
    public func fetchMoviesByCategory(_ category: String) async throws -> [Movie] {
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { $0.category == category },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        let entities = try modelContext.fetch(descriptor)
        return entities.toDomain()
    }
    
    public func saveMoviesByCategory(_ data: [Movie], category: String) async throws {
        data.forEach {
            modelContext.insert(MovieEntity($0, category: category))
        }
        try modelContext.save()
    }
    
    public func clearAllMovies() async throws {
        try modelContext.delete(model: MovieEntity.self)
        try modelContext.save()
    }
    
    public func fetchMovieDetails(_ movieId: Int) async throws -> MovieDetails? {
        let descriptor = FetchDescriptor<MovieDetailsEntity>(
            predicate: #Predicate { $0.id == movieId }
        )
        return try modelContext.fetch(descriptor).first?.toDomain()
    }
    
    public func saveMovieDetails(_ data: MovieDetails) async throws {
        modelContext.insert(MovieDetailsEntity(data))
        try modelContext.save()
    }
}
