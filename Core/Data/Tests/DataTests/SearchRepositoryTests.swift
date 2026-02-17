//
//  SearchRepositoryTests.swift
//  Data
//
//  Created by Esekiel Surbakti on 17/02/26.
//

import Testing
import Model
import Network
@testable import Data

@Suite
struct SearchRepositoryTests {

    private func makeSUT() -> (sut: SearchRepository, service: MockMovieService, genreDao: MockGenreDao, movieDao: MockMovieDao) {
        let service = MockMovieService()
        let genreDao = MockGenreDao()
        let movieDao = MockMovieDao()
        let sut = SearchRepository(service: service, genreDao: genreDao, movieDao: movieDao)
        return (sut, service, genreDao, movieDao)
    }

    @Test func searchMoviesSuccess() async throws {
        let (sut, service, genreDao, _) = makeSUT()
        let genres = [Genre(id: 18, name: "Drama"), Genre(id: 80, name: "Crime")]
        let movies = [Movie(id: 278, title: "The Shawshank Redemption", genreIds: [18, 80])]
        await service.setMockSearchResponse(MovieResponse(page: 1, results: movies, totalPages: 1, totalResults: 1))
        try await genreDao.save(genres)

        let result = try await sut.searchMovies("shaw", page: 1)

        #expect(result.results.count == 1)
        #expect(result.results[0].genres?.count == 2)
        #expect(result.results[0].genres?[0].name == "Drama")
    }

    @Test func searchMoviesFailure() async {
        let (sut, service, _, _) = makeSUT()
        await service.setShouldThrowError(true)

        await #expect(throws: Error.self) {
            _ = try await sut.searchMovies("shaw", page: 1)
        }
    }

    @Test func fetchRecommendationsSuccess() async throws {
        let (sut, _, _, movieDao) = makeSUT()
        try await movieDao.save(Movie.stubs, category: "popular")

        let result = try await sut.fetchRecommendations()

        #expect(result.count == Movie.stubs.count)
    }
}
