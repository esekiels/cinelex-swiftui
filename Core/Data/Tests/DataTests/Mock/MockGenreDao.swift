//
//  MockGenreDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Database
import Model

final actor MockGenreDao: GenreDaoProtocol {

    private var genres: [Genre] = []
    private(set) var saveCalled = false

    func seedGenres(_ genres: [Genre]) {
        self.genres = genres
    }

    func fetchGenres() async throws -> [Genre] {
        genres
    }

    func saveGenres(_ data: [Genre]) async throws {
        saveCalled = true
        genres = data
    }

    func clearAll() async throws {
        genres.removeAll()
    }
}
