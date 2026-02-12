//
//  MockMovieDetailsDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Model
import Database

final actor MockMovieDetailsDao: MovieDetailsDaoProtocol {
    
    private var storage: [Int: MovieDetails] = [:]
    
    private(set) var fetchCalled = false
    private(set) var saveCalled = false
    private(set) var deleteCalled = false
    
    func fetch(_ id: Int) async throws -> MovieDetails? {
        fetchCalled = true
        return storage[id]
    }
    
    func save(_ data: MovieDetails) async throws {
        saveCalled = true
        storage[data.id] = data
    }
    
    func delete(_ id: Int) async throws {
        deleteCalled = true
        storage[id] = nil
    }
    
    func seedCache(_ data: MovieDetails) {
        storage[data.id] = data
    }
}
