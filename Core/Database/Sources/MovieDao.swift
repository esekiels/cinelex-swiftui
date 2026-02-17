//
//  MovieDao.swift
//  Database
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation
import Model

public protocol MovieDaoProtocol: Sendable {
    func fetch(_ category: String) async throws -> [Movie]
    func save(_ data: [Movie], category: String) async throws
    func delete(_ category: String) async throws
    func deleteAll() async throws
}

public actor MovieDao: MovieDaoProtocol {
    
    private let container: ModelContainer
    private let modelContext: ModelContext
    
    public init(container: ModelContainer = DatabaseManager.shared.container) {
        self.container = container
        self.modelContext = ModelContext(container)
    }
    
    public func fetch(_ category: String) async throws -> [Movie] {
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { $0.category == category },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        let entities = try modelContext.fetch(descriptor)
        return entities.map { $0.toDomain() }
    }
    
    public func save(_ data: [Movie], category: String) async throws {
        try await delete(category)
        
        data.forEach {
            modelContext.insert(MovieEntity($0, category: category))
        }
        try modelContext.save()
    }
    
    public func delete(_ category: String) async throws {
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { $0.category == category }
        )
        let entities = try modelContext.fetch(descriptor)
        for entity in entities {
            modelContext.delete(entity)
        }
        try modelContext.save()
    }
    
    public func deleteAll() async throws {
        try modelContext.delete(model: MovieEntity.self)
        try modelContext.save()
    }
}
