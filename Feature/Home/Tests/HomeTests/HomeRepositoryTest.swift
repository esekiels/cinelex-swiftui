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
    
    @Test @MainActor func fetchMoviesSuccess() async {
        let (sut, repository) = makeSUT()
        await repository.setMockMovies(Movie.stubs)
        
        await sut.refresh()
        
        #expect(sut.nowPlayingState.isIdle)
        #expect(sut.popularState.isIdle)
        #expect(sut.topRatedState.isIdle)
        #expect(sut.upcomingState.isIdle)
        #expect(sut.nowPlaying.count == Movie.stubs.count)
        #expect(sut.nowPlaying[0].title == "The Shawshank Redemption")
    }
    
    @Test @MainActor func fetchMoviesError() async {
        let (sut, repository) = makeSUT()
        await repository.setShouldThrowError(true)
        
        await sut.refresh()
        
        #expect(sut.nowPlayingState.isError)
        #expect(sut.popularState.isError)
        #expect(sut.nowPlaying.isEmpty)
    }
}
