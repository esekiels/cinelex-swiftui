import Data
import Model

final actor MockGenreRepository: GenreRepositoryProtocol {

    private var mockGenres: [Genre] = []
    var shouldThrowError = false

    func setMockGenres(_ genres: [Genre]) {
        mockGenres = genres
    }

    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func fetchGenres() async throws -> [Genre] {
        if shouldThrowError { throw NSError(domain: "", code: 0) }
        return mockGenres
    }
}
