//
//  MockDetailsRepository.swift
//  Details
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Model
import Data
import Foundation

final actor MockDetailsRepository: DetailsRepositoryProtocol {
    
    private var mockDetails: MovieDetails?
    private var shouldThrowError = false
    
    func setMockDetails(_ details: MovieDetails) {
        mockDetails = details
    }
    
    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }
    
    func fetchDetails(_ id: Int) async throws -> MovieDetails {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        guard let mockDetails else { throw NSError(domain: "No mock", code: 0) }
        return mockDetails
    }
}
