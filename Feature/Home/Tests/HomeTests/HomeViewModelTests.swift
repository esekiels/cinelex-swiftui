//
//  HomeRepositoryTest.swift
//  Home
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Testing
import Model
import Common
@testable import Home

@Suite
@MainActor
struct HomeViewModelTests {

    private func makeSUT() -> (sut: HomeViewModel, repository: MockHomeRepository) {
        let repository = MockHomeRepository()
        let sut = HomeViewModel(repository: repository)
        return (sut, repository)
    }

    @Test func fetchMoviesSuccess() async {
        let (sut, repository) = makeSUT()
        await repository.setMockMovies(Movie.stubs)

        await sut.refresh()

        #expect(sut.state.isIdle)
        #expect(sut.nowPlaying.count == Movie.stubs.count)
        #expect(sut.popular.count == Movie.stubs.count)
        #expect(sut.topRated.count == Movie.stubs.count)
        #expect(sut.upcoming.count == Movie.stubs.count)
        #expect(sut.nowPlaying[0].title == "The Shawshank Redemption")
    }

    @Test func fetchMoviesError() async {
        let (sut, repository) = makeSUT()
        await repository.setShouldThrowError(true)

        await sut.refresh()

        #expect(sut.state.isError)
        #expect(sut.nowPlaying.isEmpty)
        #expect(sut.popular.isEmpty)
        #expect(sut.topRated.isEmpty)
        #expect(sut.upcoming.isEmpty)
    }
}
