//
//  DetailsRepositoryTests.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Testing
import Model
@testable import Data

@Suite struct DetailsRepositoryTests {
    
    private func makeSUT() -> (sut: DetailsRepository, service: MockMovieService, dao: MockMovieDetailsDao) {
        let service = MockMovieService()
        let dao = MockMovieDetailsDao()
        let sut = DetailsRepository(service: service, dao: dao)
        return (sut, service, dao)
    }
    
    @Test func fetchDetailsFromNetwork() async throws {
        let (sut, service, dao) = makeSUT()
        
        let result = try await sut.fetchDetails(278)
        
        #expect(result.id == 278)
        #expect(result.title == "The Shawshank Redemption")
        #expect(await service.fetchDetailsCalled == true)
        #expect(await dao.saveCalled == true)
    }
    
    @Test func fetchDetailsFromCacheWhenNetworkFails() async throws {
        let (sut, service, dao) = makeSUT()
        await dao.seedCache(MovieDetails.stub)
        await service.setShouldThrowError(true)
        
        let result = try await sut.fetchDetails(278)
        
        #expect(result.id == 278)
        #expect(result.title == "The Shawshank Redemption")
        #expect(await dao.fetchCalled == true)
    }
    
    @Test func fetchDetailsThrowsWhenNetworkFailsAndCacheEmpty() async {
        let (sut, service, _) = makeSUT()
        await service.setShouldThrowError(true)
        
        await #expect(throws: Error.self) {
            _ = try await sut.fetchDetails(278)
        }
    }
}
