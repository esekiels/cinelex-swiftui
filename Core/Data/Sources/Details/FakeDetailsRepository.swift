//
//  FakeDetailsRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Model

public final class FakeDetailsRepository: DetailsRepositoryProtocol {
    
    public init() {}
    
    public func fetchDetails(_ id: Int) async throws -> MovieDetails {
        MovieDetails.stub
    }
}
