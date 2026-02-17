//
//  MockMovieDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Model
import Database

final actor MockMovieDao: MovieDaoProtocol {
    
    private var storage: [String: [Movie]] = [:]
    
    private(set) var fetchCalled = false
    private(set) var saveCalled = false
    private(set) var deleteCalled = false
    private(set) var lastCategory: String?
    
    func fetch(_ category: String) async throws -> [Movie] {
        fetchCalled = true
        lastCategory = category
        return storage[category] ?? []
    }
    
    func save(_ data: [Movie], category: String) async throws {
        saveCalled = true
        lastCategory = category
        storage[category] = data
    }
    
    func delete(_ category: String) async throws {
        deleteCalled = true
        storage[category] = nil
    }
    
    func deleteAll() async throws {
        storage.removeAll()
    }
    
    func seedCache(_ data: [Movie], category: String) {
        storage[category] = data
    }
}
