//
//  GenreDao.swift
//  Database
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Foundation
import Model

public protocol GenreDaoProtocol: Sendable {
    func fetch() async throws -> [Genre]
    func save(_ data: [Genre]) async throws
    func deleteAll() async throws
}

public actor GenreDao: GenreDaoProtocol {

    private let container: ModelContainer
    private let modelContext: ModelContext

    public init(container: ModelContainer = DatabaseManager.shared.container) {
        self.container = container
        self.modelContext = ModelContext(container)
    }

    public func fetch() async throws -> [Genre] {
        let descriptor = FetchDescriptor<GenreEntity>(
            sortBy: [SortDescriptor(\.id)]
        )
        let entities = try modelContext.fetch(descriptor)
        return entities.toDomain()
    }

    public func save(_ data: [Genre]) async throws {
        for genre in data {
            let id = genre.id
            let descriptor = FetchDescriptor<GenreEntity>(
                predicate: #Predicate { $0.id == id }
            )
            let existing = try modelContext.fetch(descriptor)

            if let entity = existing.first {
                entity.name = genre.name
            } else {
                let entity = GenreEntity(id: genre.id, name: genre.name)
                modelContext.insert(entity)
            }
        }
        try modelContext.save()
    }

    public func deleteAll() async throws {
        try modelContext.delete(model: GenreEntity.self)
        try modelContext.save()
    }
}
