import Data
import Model

final actor MockMovieRepository: MovieRepositoryProtocol {

    private var mockMovies: [Movie] = []
    private var mockDetails: MovieDetails = MovieDetails.stub
    private var mockSearchTotalPages: Int = 1
    var shouldThrowError = false

    func setMockMovies(_ movies: [Movie], totalPages: Int = 1) {
        mockMovies = movies
        mockSearchTotalPages = totalPages
    }

    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func fetchNowPlaying() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockMovies
    }

    func fetchUpcoming() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockMovies
    }

    func fetchPopular() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockMovies
    }

    func fetchTopRated() async throws -> [Movie] {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockMovies
    }

    func fetchMoveDetails(_ movieId: Int) async throws -> MovieDetails {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockDetails
    }

    func searchMovies(query: String, page: Int) async throws -> PageResult<Movie> {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return PageResult(page: page, totalPages: mockSearchTotalPages, results: mockMovies)
    }
}
