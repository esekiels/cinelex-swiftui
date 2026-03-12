//
//  GenreRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Networking
import Database
import Model
import Common

public protocol GenreRepositoryProtocol: Sendable {
    func fetchGenres() -> AsyncStream<[Genre]>
}

public final class GenreRepository: GenreRepositoryProtocol {

    private let service: GenreServiceProtocol
    private let dao: GenreDaoProtocol

    public init(service: GenreServiceProtocol, dao: GenreDaoProtocol) {
        self.service = service
        self.dao = dao
    }

    public func fetchGenres() -> AsyncStream<[Genre]> {
        .onDataStream(
            dao: { [dao] in
                let items = try await dao.fetchGenres()
                return items.isEmpty ? nil : items
            },
            service: { [service] in try await service.fetchGenres() },
            then: { [dao] in try await dao.saveGenres($0) }
        )
    }
}
