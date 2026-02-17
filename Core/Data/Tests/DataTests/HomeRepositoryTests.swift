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
    
    private func makeSUT() -> (
        sut: HomeRepository,
        service: MockMovieService,
        genreService: MockGenreService,
        dao: MockMovieDao,
        genreDao: MockGenreDao
    ) {
        let service = MockMovieService()
        let genreService = MockGenreService()
        let dao = MockMovieDao()
        let genreDao = MockGenreDao()
        
        let sut = HomeRepository(service: service, genreService: genreService, dao: dao, genreDao: genreDao)
        return (sut, service, genreService, dao, genreDao)
    }
    
    @Test func fetchMoviesFromNetwork() async throws {
        let (sut, service, _, dao, _) = makeSUT()
        await service.setMockMovies(Movie.stubs)
        
        let movies = try await sut.fetchNowPlaying()
        
        #expect(movies.count == Movie.stubs.count)
        #expect(movies[0].title == "The Shawshank Redemption")
        #expect(await service.fetchNowPlayingCalled == true)
        #expect(await dao.fetchCalled == true)
    }

    @Test func fetchMoviesFromCacheWhenNetworkFails() async throws {
        let (sut, service, _, dao, _) = makeSUT()
        await dao.seedCache(Movie.stubs, category: "nowPlaying")
        await service.setShouldThrowError(true)
        
        let movies = try await sut.fetchNowPlaying()
        
        #expect(movies.count == Movie.stubs.count)
        #expect(movies[0].title == "The Shawshank Redemption")
        #expect(await dao.fetchCalled == true)
    }

    @Test func fetchMoviesNetworkErrorWithEmptyCache() async {
        let (sut, service, _, _, _) = makeSUT()
        await service.setShouldThrowError(true)
        
        await #expect(throws: Error.self) {
            _ = try await sut.fetchNowPlaying()
        }
    }
    
    @Test func fetchGenresFromNetwork() async throws {
        let (sut, _, genreService, _, genreDao) = makeSUT()
        await genreService.setMockGenres(Genre.stubs)
        
        await sut.fetchGenres()
        
        #expect(await genreService.fetchGenresCalled == true)
        #expect(await genreDao.deleteCalled == true)
        #expect(await genreDao.saveCalled == true)
    }
}
