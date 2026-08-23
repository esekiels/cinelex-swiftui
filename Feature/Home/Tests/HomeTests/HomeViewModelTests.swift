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

        #expect(sut.state == .idle)
        #expect(sut.nowPlaying.count == Movie.stubs.count)
        #expect(sut.popular.count == Movie.stubs.count)
        #expect(sut.topRated.count == Movie.stubs.count)
        #expect(sut.upcoming.count == Movie.stubs.count)
        #expect(sut.nowPlaying[0].title == "The Shawshank Redemption")
    }

    @Test func cachedMoviesSurviveNetworkFailure() async {
        let (sut, repository) = makeSUT()
        repository.errorAfterSuccess = true
        repository.error = .timeout

        sut.fetchMovies()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state == .idle)
        #expect(sut.nowPlaying.count == Movie.stubs.count)
        #expect(sut.popular.count == Movie.stubs.count)
    }

    @Test func fetchMoviesFailureSurfacesError() async {
        let (sut, repository) = makeSUT()
        repository.error = .timeout

        sut.fetchMovies()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state == .error(.timeout))
        #expect(sut.nowPlaying.isEmpty)
    }
}
