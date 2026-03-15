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
        repository.setMockDetails(MovieDetails.stub)

        sut.fetchDetails()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.isIdle)
        #expect(sut.movie != nil)
        #expect(sut.movie?.id == 278)
        #expect(sut.movie?.title == "The Shawshank Redemption")
    }
}
