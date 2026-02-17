//
//  DetailsViewModelTests.swift
//  Details
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Testing
import Model
import Common
@testable import Details

@Suite
@MainActor
struct DetailsViewModelTests {
    
    private func makeSUT() -> (sut: DetailsViewModel, repository: MockDetailsRepository) {
        let repository = MockDetailsRepository()
        let sut = DetailsViewModel(repository: repository, movieId: 278)
        return (sut, repository)
    }
    
    @Test func fetchDetailsSuccess() async {
        let (sut, repository) = makeSUT()
        await repository.setMockDetails(MovieDetails.stub)
        
        await sut.fetchDetails()
        
        #expect(sut.state.isIdle)
        #expect(sut.movie != nil)
        #expect(sut.movie?.id == 278)
        #expect(sut.movie?.title == "The Shawshank Redemption")
    }
    
    @Test func fetchDetailsError() async {
        let (sut, repository) = makeSUT()
        await repository.setShouldThrowError(true)
        
        await sut.fetchDetails()
        
        #expect(sut.state.isError)
        #expect(sut.movie == nil)
    }
}
