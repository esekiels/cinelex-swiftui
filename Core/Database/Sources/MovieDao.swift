//
//  MovieDao.swift
//  Database
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation
import Model

public protocol MovieDaoProtocol: BaseDaoProtocol where T == [Movie] {
    func getDetails(_ movieId: Int) async throws -> MovieDetails
    func saveDetails(_ data: MovieDetails) async throws
}

public actor MovieDao: MovieDaoProtocol {

    private let category: String
    private let modelContext: ModelContext

    public init(
        category: String = "",
        container: ModelContainer = DatabaseManager.shared.container
    ) {
        self.category = category
        self.modelContext = ModelContext(container)
    }

    public func get() async throws -> [Movie] {
        let category = self.category
        let descriptor = FetchDescriptor<MovieEntity>(
            predicate: #Predicate { $0.category == category },
            sortBy: [SortDescriptor(\.createdAt)]
        )
        return try modelContext.fetch(descriptor).toDomain()
    }

    public func save(_ data: [Movie]) async throws {
        data.forEach {
            modelContext.insert(MovieEntity($0, category: category))
        }
        try modelContext.save()
    }

    public func getDetails(_ movieId: Int) async throws -> MovieDetails {
        guard let entity = try fetchDetails(movieId).first else {
            throw DatabaseError.notFound
        }
        return entity.toDomain()
    }

    public func saveDetails(_ data: MovieDetails) async throws {
        try deleteDetails(data.id)
        modelContext.insert(MovieDetailsEntity(data))
        try modelContext.save()
    }

    private func deleteDetails(_ movieId: Int) throws {
        for entity in try fetchDetails(movieId) {
            modelContext.delete(entity)
        }
        try modelContext.save()
    }

    private func fetchDetails(_ movieId: Int) throws -> [MovieDetailsEntity] {
        let descriptor = FetchDescriptor<MovieDetailsEntity>(
            predicate: #Predicate { $0.id == movieId }
        )
        return try modelContext.fetch(descriptor)
    }
}
