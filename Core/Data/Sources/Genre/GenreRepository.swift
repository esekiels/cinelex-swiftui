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
    func fetchGenres() -> DataStream<[Genre]>
}

public final class GenreRepository: GenreRepositoryProtocol {

    private let service: GenreServiceProtocol
    private let dao: any BaseDaoProtocol<[Genre]>

    public init(service: GenreServiceProtocol, dao: any BaseDaoProtocol<[Genre]> = GenreDao()) {
        self.service = service
        self.dao = dao
    }

    public func fetchGenres() -> DataStream<[Genre]> {
        .onDataStream(
            dao: { [dao] in
                let items = try await dao.get()
                return items.isEmpty ? nil : items
            },
            service: { [service] in try await service.fetchGenres() },
            then: { [dao] in try await dao.save($0) }
        )
    }
}
