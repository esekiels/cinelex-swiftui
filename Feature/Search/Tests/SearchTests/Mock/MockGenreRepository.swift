//
//  MockGenreRepository.swift
//  Search
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Data
import Model

final class MockGenreRepository: GenreRepositoryProtocol, @unchecked Sendable {

    private var mockGenres: [Genre] = []

    func setMockGenres(_ genres: [Genre]) {
        mockGenres = genres
    }

    func fetchGenres() -> AsyncStream<[Genre]> {
        .just(mockGenres)
    }
}
