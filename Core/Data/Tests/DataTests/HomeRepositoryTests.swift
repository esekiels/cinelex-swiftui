//
//  HomeRepositoryTests.swift
//  Data
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Testing
import Model
@testable import Data

@Suite struct HomeRepositoryTests {
    
    private func makeSUT() -> (sut: HomeRepository, dao: MockMovieDao, service: MockMovieService) {
        let dao = MockMovieDao()
        let service = MockMovieService()
        let sut = HomeRepository(dao: dao, service: service)
        return (sut, dao, service)
    }
    
    @Test func fetchMoviesFromNetwork() async throws {
        let (sut, dao, service) = makeSUT()
        await service.setMockMovies(Movie.stubs)
        
        let movies = try await sut.fetchNowPlaying()
        
        #expect(movies.count == Movie.stubs.count)
        #expect(movies[0].title == "The Shawshank Redemption")
        #expect(await service.fetchNowPlayingCalled == true)
        #expect(await dao.fetchCalled == true)
    }

    @Test func fetchMoviesFromCache() async throws {
        let (sut, dao, service) = makeSUT()
        await dao.seedCache(Movie.stubs, category: "nowPlaying")
        
        let movies = try await sut.fetchNowPlaying()
        
        #expect(movies.count == Movie.stubs.count)
        #expect(movies[0].title == "The Shawshank Redemption")
        #expect(await dao.fetchCalled == true)
        #expect(await service.fetchNowPlayingCalled == false)
    }

    @Test func fetchMoviesNetworkErrorWithEmptyCache() async {
        let (sut, _, service) = makeSUT()
        await service.setShouldThrowError(true)
        
        await #expect(throws: Error.self) {
            _ = try await sut.fetchNowPlaying()
        }
    }
}
