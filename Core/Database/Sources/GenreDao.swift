//
//  GenreDao.swift
//  Database
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Foundation
import Model

public actor GenreDao: BaseDaoProtocol {

    private let modelContext: ModelContext

    public init(container: ModelContainer = DatabaseManager.shared.container) {
        self.modelContext = ModelContext(container)
    }

    public func get() async throws -> [Genre] {
        let descriptor = FetchDescriptor<GenreEntity>(
            sortBy: [SortDescriptor(\.id)]
        )
        return try modelContext.fetch(descriptor).toDomain()
    }

    public func save(_ data: [Genre]) async throws {
        for genre in data {
            let id = genre.id
            let descriptor = FetchDescriptor<GenreEntity>(
                predicate: #Predicate { $0.id == id }
            )

            if let entity = try modelContext.fetch(descriptor).first {
                entity.name = genre.name
            } else {
                modelContext.insert(GenreEntity(id: genre.id, name: genre.name))
            }
        }
        try modelContext.save()
    }
}
