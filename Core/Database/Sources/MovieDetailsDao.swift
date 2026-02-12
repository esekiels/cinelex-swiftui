//
//  MovieDetailsDao.swift
//  Database
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Foundation
import Model

public protocol MovieDetailsDaoProtocol: Sendable {
    func fetch(_ id: Int) async throws -> MovieDetails?
    func save(_ data: MovieDetails) async throws
    func delete(_ id: Int) async throws
}

public actor MovieDetailsDao: MovieDetailsDaoProtocol {
    
    private let container: ModelContainer
    private let modelContext: ModelContext
    
    public init(container: ModelContainer = DatabaseManager.shared.container) {
        self.container = container
        self.modelContext = ModelContext(container)
    }
    
    public func fetch(_ id: Int) async throws -> MovieDetails? {
        let descriptor = FetchDescriptor<MovieDetailsEntity>(
            predicate: #Predicate { $0.id == id }
        )
        return try modelContext.fetch(descriptor).first?.toDomain()
    }
    
    public func save(_ data: MovieDetails) async throws {
        try await delete(data.id)
        modelContext.insert(MovieDetailsEntity(data))
        try modelContext.save()
    }
    
    public func delete(_ id: Int) async throws {
        let descriptor = FetchDescriptor<MovieDetailsEntity>(
            predicate: #Predicate { $0.id == id }
        )
        let entities = try modelContext.fetch(descriptor)
        for entity in entities {
            modelContext.delete(entity)
        }
        try modelContext.save()
    }
}
