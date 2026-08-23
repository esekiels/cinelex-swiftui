import Testing
import Common
import Data
import Model
@testable import Details

@Suite
@MainActor
struct DetailsViewModelTests {

    private func makeSUT() -> (sut: DetailsViewModel, repository: FakeMovieRepository) {
        let repository = FakeMovieRepository()
        let sut = DetailsViewModel(repository: repository, movieId: 278)
        return (sut, repository)
    }

    @Test func fetchDetailsSuccess() async {
        let (sut, _) = makeSUT()

        sut.fetchDetails()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state == .idle)
        #expect(sut.movie != nil)
        #expect(sut.movie?.id == 278)
        #expect(sut.movie?.title == "The Shawshank Redemption")
    }

    @Test func cachedDetailsSurviveNetworkFailure() async {
        let (sut, repository) = makeSUT()
        repository.errorAfterSuccess = true
        repository.error = .notFound

        sut.fetchDetails()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state == .idle)
        #expect(sut.movie?.id == 278)
    }

    @Test func fetchDetailsFailureSurfacesError() async {
        let (sut, repository) = makeSUT()
        repository.error = .notFound

        sut.fetchDetails()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state == .error(.notFound))
        #expect(sut.movie == nil)
    }
}
