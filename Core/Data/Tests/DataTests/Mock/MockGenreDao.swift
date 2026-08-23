//
//  MockGenreDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Database
import Model

final actor MockGenreDao: BaseDaoProtocol {

    private var genres: [Genre] = []
    private(set) var saveCalled = false

    func seed(_ genres: [Genre]) {
        self.genres = genres
    }

    func get() async throws -> [Genre] {
        genres
    }

    func save(_ data: [Genre]) async throws {
        saveCalled = true
        genres = data
    }
}
