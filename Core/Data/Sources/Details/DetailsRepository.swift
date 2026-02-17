//
//  DetailsRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Model
import Network
import Database

public protocol DetailsRepositoryProtocol: Sendable {
    
    func fetchDetails(_ id: Int) async throws -> MovieDetails
}

public final class DetailsRepository: DetailsRepositoryProtocol {
    
    private let service: MovieServiceProtocol
    private let dao: MovieDetailsDaoProtocol
    
    public init(service: MovieServiceProtocol, dao: MovieDetailsDaoProtocol) {
        self.service = service
        self.dao = dao
    }
    
    public func fetchDetails(_ id: Int) async throws -> MovieDetails {
        do {
            let details = try await service.fetchDetails(id)
            try? await dao.save(details)
            return details
        } catch {
            if let cached = try? await dao.fetch(id) {
                return cached
            }
            throw error
        }
    }
}
