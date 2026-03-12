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
        repository.setMockMovies(Movie.stubs)

        sut.fetchMovies()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.isIdle)
        #expect(sut.nowPlaying.count == Movie.stubs.count)
        #expect(sut.popular.count == Movie.stubs.count)
        #expect(sut.topRated.count == Movie.stubs.count)
        #expect(sut.upcoming.count == Movie.stubs.count)
        #expect(sut.nowPlaying[0].title == "The Shawshank Redemption")
    }
}
