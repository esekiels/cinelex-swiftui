import Model
import Data

final class MockDetailsRepository: MovieRepositoryProtocol, @unchecked Sendable {

    private var mockMovies: [Movie] = []
    private var mockDetails: MovieDetails = MovieDetails.stub

    func setMockDetails(_ details: MovieDetails) {
        mockDetails = details
    }

    func fetchNowPlaying() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchPopular() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchTopRated() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchUpcoming() -> AsyncStream<[Movie]> {
        .just(mockMovies)
    }

    func fetchMovieDetails(_ movieId: Int) -> AsyncStream<MovieDetails> {
        .just(mockDetails)
    }

    func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        PageResult(page: page, totalPages: 1, results: mockMovies)
    }
}
