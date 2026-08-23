//
//  MockMovieDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Database
import Model

final actor MockMovieDao: MovieDaoProtocol {

    private var movies: [Movie] = []
    private var details: MovieDetails?
    private(set) var saveCalled = false
    private(set) var saveDetailsCalled = false

    func seed(_ movies: [Movie]) {
        self.movies = movies
    }

    func seedDetails(_ details: MovieDetails) {
        self.details = details
    }

    func get() async throws -> [Movie] {
        movies
    }

    func save(_ data: [Movie]) async throws {
        saveCalled = true
        movies = data
    }

    func getDetails(_ movieId: Int) async throws -> MovieDetails {
        guard let details else {
            throw DatabaseError.notFound
        }
        return details
    }

    func saveDetails(_ data: MovieDetails) async throws {
        saveDetailsCalled = true
        details = data
    }
}
