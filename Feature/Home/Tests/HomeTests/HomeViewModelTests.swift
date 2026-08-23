import Testing
import Common
import Data
import Model
@testable import Home

@Suite
@MainActor
struct HomeViewModelTests {

    private func makeSUT() -> (sut: HomeViewModel, repository: FakeMovieRepository) {
        let repository = FakeMovieRepository()
        let sut = HomeViewModel(repository: repository)
        return (sut, repository)
    }

    @Test func fetchMoviesSuccess() async {
        let (sut, _) = makeSUT()

        sut.fetchMovies()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.uiState == .idle)
        #expect(sut.state.nowPlaying.count == Movie.stubs.count)
        #expect(sut.state.popular.count == Movie.stubs.count)
        #expect(sut.state.topRated.count == Movie.stubs.count)
        #expect(sut.state.upcoming.count == Movie.stubs.count)
        #expect(sut.state.nowPlaying[0].title == "The Shawshank Redemption")
    }

    @Test func cachedMoviesSurviveNetworkFailure() async {
        let (sut, repository) = makeSUT()
        repository.errorAfterSuccess = true
        repository.error = .timeout

        sut.fetchMovies()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.uiState == .idle)
        #expect(sut.state.nowPlaying.count == Movie.stubs.count)
        #expect(sut.state.popular.count == Movie.stubs.count)
    }

    @Test func fetchMoviesFailureSurfacesError() async {
        let (sut, repository) = makeSUT()
        repository.error = .timeout

        sut.fetchMovies()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.uiState == .error(.timeout))
        #expect(sut.state.nowPlaying.isEmpty)
    }
}
