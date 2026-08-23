import Testing
import Common
import Data
import Model
@testable import Search

@Suite
@MainActor
struct SearchViewModelTests {

    private func makeSUT() -> (sut: SearchViewModel, movieRepo: FakeMovieRepository) {
        let movieRepo = FakeMovieRepository()
        let sut = SearchViewModel(
            movieRepository: movieRepo,
            genreRepository: FakeGenreRepository()
        )
        return (sut, movieRepo)
    }

    @Test func searchMoviesSuccess() async {
        let (sut, _) = makeSUT()

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        #expect(sut.state.uiState == .idle)
        #expect(sut.state.movies.count == Movie.stubs.count)
        #expect(sut.state.movies[0].title == "The Shawshank Redemption")
    }

    @Test func searchMoviesFailure() async {
        let (sut, movieRepo) = makeSUT()
        movieRepo.error = .timeout

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        #expect(sut.state.uiState == .error(.timeout))
        #expect(sut.state.movies.isEmpty)
    }

    @Test func clearQueryResetsState() async {
        let (sut, _) = makeSUT()

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))
        sut.query = ""

        #expect(sut.state.uiState == .idle)
        #expect(sut.state.movies.isEmpty)
    }

    @Test func loadSuccess() async {
        let (sut, _) = makeSUT()

        sut.load()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.recommendations.count == Movie.stubs.count)
    }

    @Test func loadMoreSuccess() async throws {
        let (sut, movieRepo) = makeSUT()
        movieRepo.totalPages = 3

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        guard let lastMovie = sut.state.movies.last else {
            Issue.record("Expected movies to be loaded")
            return
        }

        sut.loadMoreIfNeeded(current: lastMovie)
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.state.movies.count == Movie.stubs.count * 2)
    }
}
