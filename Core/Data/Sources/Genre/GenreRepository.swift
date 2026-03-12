//
//  GenreRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Networking
import Database
import Model

public protocol GenreRepositoryProtocol: Sendable {
    func fetchGenres() async throws -> [Genre]
}

public final class GenreRepository: GenreRepositoryProtocol {
    
    private let service: GenreServiceProtocol
    private let dao: GenreDaoProtocol
    
    public init(service: GenreServiceProtocol, dao: GenreDaoProtocol) {
        self.service = service
        self.dao = dao
    }
    
    public func fetchGenres() async throws -> [Genre] {
        if let cachedItems = try? await dao.fetchGenres(), !cachedItems.isEmpty {
            Task {
                let genres = try await service.fetchGenres()
                try await dao.saveGenres(genres)
            }
            
            return cachedItems
        }
        
        let genres = try await service.fetchGenres()
        
        Task {
            try? await dao.saveGenres(genres)
        }
        
        return genres
    }
}
