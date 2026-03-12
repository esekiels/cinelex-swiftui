//
//  MovieRepositoryTests.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Testing
import Model
import Networking
@testable import Data

@Suite
struct MovieRepositoryTests {

    private func makeSUT() -> (sut: MovieRepository, service: MockMovieService, dao: MockMovieDao) {
        let service = MockMovieService()
        let dao = MockMovieDao()
        let sut = MovieRepository(service: service, dao: dao)
        return (sut, service, dao)
    }

    private func collect<T>(_ stream: AsyncStream<T>) async -> [T] {
        var values: [T] = []
        for await value in stream { values.append(value) }
        return values
    }

    // MARK: - Fetch Movies

    @Test func fetchMoviesFromNetwork() async {
        let (sut, service, _) = makeSUT()
        await service.setMockMovies(Movie.stubs)

        let results = await collect(sut.fetchNowPlaying())

        #expect(results.count == 1)
        #expect(results[0].count == Movie.stubs.count)
    }

    @Test func fetchMoviesFromCacheThenNetwork() async {
        let (sut, service, dao) = makeSUT()
        await dao.seedMovies(Movie.stubs, category: "nowPlaying")
        await service.setMockMovies(Movie.stubs)

        let results = await collect(sut.fetchNowPlaying())

        #expect(results.count == 2)
        #expect(results[0].count == Movie.stubs.count)
        #expect(results[1].count == Movie.stubs.count)
    }

    @Test func fetchMoviesSavesToDao() async {
        let (sut, service, dao) = makeSUT()
        await service.setMockMovies(Movie.stubs)

        _ = await collect(sut.fetchPopular())

        #expect(await dao.saveCategoryCalled == true)
    }

    // MARK: - Fetch Details

    @Test func fetchDetailsFromNetwork() async {
        let (sut, _, _) = makeSUT()

        let results = await collect(sut.fetchMovieDetails(278))

        #expect(results.count == 1)
        #expect(results[0].id == 278)
    }

    @Test func fetchDetailsFromCacheThenNetwork() async {
        let (sut, _, dao) = makeSUT()
        await dao.seedDetails(MovieDetails.stub)

        let results = await collect(sut.fetchMovieDetails(278))

        #expect(results.count == 2)
        #expect(results[0].id == 278)
        #expect(results[1].id == 278)
    }

    @Test func fetchDetailsSavesToDao() async {
        let (sut, _, dao) = makeSUT()

        _ = await collect(sut.fetchMovieDetails(278))

        #expect(await dao.saveDetailsCalled == true)
    }

    // MARK: - Search Movies

    @Test func searchMoviesSuccess() async throws {
        let (sut, service, _) = makeSUT()
        let response = MovieResponse(page: 1, results: Movie.stubs, totalPages: 2, totalResults: 10)
        await service.setMockSearchResponse(response)

        let result = try await sut.searchMovies(query: "shaw", page: 1)

        #expect(result.page == 1)
        #expect(result.totalPages == 2)
        #expect(result.results.count == Movie.stubs.count)
    }

    @Test func searchMoviesFailure() async {
        let (sut, service, _) = makeSUT()
        await service.setShouldThrowError(true)

        await #expect(throws: Error.self) {
            _ = try await sut.searchMovies(query: "shaw", page: 1)
        }
    }
}
