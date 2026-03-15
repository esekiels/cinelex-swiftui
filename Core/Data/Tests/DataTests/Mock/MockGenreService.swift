//
//  MockGenreService.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Networking
import Model
import Foundation

final actor MockGenreService: GenreServiceProtocol {

    private var mockGenres: [Genre] = []
    var shouldThrowError = false

    func setMockGenres(_ genres: [Genre]) {
        mockGenres = genres
    }

    func setShouldThrowError(_ value: Bool) {
        shouldThrowError = value
    }

    func fetchGenres() async throws -> [Genre] {
        if shouldThrowError { throw NSError(domain: "test", code: -1) }
        return mockGenres
    }
}
