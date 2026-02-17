//
//  SearchViewModelTests.swift
//  Search
//
//  Created by Esekiel Surbakti on 17/02/26.
//

import Testing
import Model
import Common
@testable import Search

@Suite
@MainActor
struct SearchViewModelTests {

    private func makeSUT() -> (sut: SearchViewModel, repository: MockSearchRepository) {
        let repository = MockSearchRepository()
        let sut = SearchViewModel(repository: repository)
        return (sut, repository)
    }

    @Test func searchMoviesSuccess() async {
        let (sut, repository) = makeSUT()
        await repository.setMockMovies(Movie.stubs)

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        #expect(sut.state.isIdle)
        #expect(sut.movies.count == Movie.stubs.count)
        #expect(sut.movies[0].title == "The Shawshank Redemption")
    }

    @Test func searchMoviesFailure() async {
        let (sut, repository) = makeSUT()
        await repository.setShouldThrowError(true)

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        #expect(sut.state.isError)
        #expect(sut.movies.isEmpty)
    }

    @Test func clearQueryResetsState() async {
        let (sut, repository) = makeSUT()
        await repository.setMockMovies(Movie.stubs)

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))
        sut.query = ""

        #expect(sut.state.isIdle)
        #expect(sut.movies.isEmpty)
    }

    @Test func loadRecommendationsSuccess() async {
        let (sut, repository) = makeSUT()
        await repository.setMockMovies(Movie.stubs)

        sut.loadRecommendations()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.recommendations.count == Movie.stubs.count)
    }

    @Test func loadMoreSuccess() async throws {
        let (sut, repository) = makeSUT()
        await repository.setMockMovies(Movie.stubs, totalPages: 3)

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        guard let lastMovie = sut.movies.last else {
            Issue.record("Expected movies to be loaded")
            return
        }

        sut.loadMoreIfNeeded(current: lastMovie)
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.movies.count == Movie.stubs.count * 2)
    }
}
