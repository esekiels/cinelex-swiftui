//
//  MockGenreDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Model
import Database

final actor MockGenreDao: GenreDaoProtocol {

    private var storage: [Genre] = []
    
    private(set) var saveCalled = false
    private(set) var deleteCalled = false

    func fetch() async throws -> [Genre] {
        storage
    }

    func save(_ data: [Genre]) async throws {
        saveCalled = true
        storage = data
    }

    func deleteAll() async throws {
        deleteCalled = true
        storage.removeAll()
    }
}
