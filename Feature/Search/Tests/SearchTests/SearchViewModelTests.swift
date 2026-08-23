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

        #expect(sut.state == .idle)
        #expect(sut.movies.count == Movie.stubs.count)
        #expect(sut.movies[0].title == "The Shawshank Redemption")
    }

    @Test func searchMoviesFailure() async {
        let (sut, movieRepo) = makeSUT()
        movieRepo.error = .timeout

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))

        #expect(sut.state == .error(.timeout))
        #expect(sut.movies.isEmpty)
    }

    @Test func clearQueryResetsState() async {
        let (sut, _) = makeSUT()

        sut.query = "shaw"
        try? await Task.sleep(for: .milliseconds(600))
        sut.query = ""

        #expect(sut.state == .idle)
        #expect(sut.movies.isEmpty)
    }

    @Test func loadSuccess() async {
        let (sut, _) = makeSUT()

        sut.load()
        try? await Task.sleep(for: .milliseconds(100))

        #expect(sut.recommendations.count == Movie.stubs.count)
    }

    @Test func loadMoreSuccess() async throws {
        let (sut, movieRepo) = makeSUT()
        movieRepo.totalPages = 3

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
