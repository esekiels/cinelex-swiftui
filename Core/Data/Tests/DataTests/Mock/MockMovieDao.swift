//
//  MockMovieDao.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Database
import Model

final actor MockMovieDao: MovieDaoProtocol {

    private var moviesByCategory: [String: [Movie]] = [:]
    private var details: [Int: MovieDetails] = [:]
    private(set) var saveCategoryCalled = false
    private(set) var saveDetailsCalled = false

    func seedMovies(_ movies: [Movie], category: String) {
        moviesByCategory[category] = movies
    }

    func seedDetails(_ detail: MovieDetails) {
        details[detail.id] = detail
    }

    func fetchMoviesByCategory(_ category: String) async throws -> [Movie] {
        moviesByCategory[category] ?? []
    }

    func saveMoviesByCategory(_ data: [Movie], category: String) async throws {
        saveCategoryCalled = true
        moviesByCategory[category] = data
    }

    func clearAllMovies() async throws {
        moviesByCategory.removeAll()
    }

    func fetchMovieDetails(_ movieId: Int) async throws -> MovieDetails? {
        details[movieId]
    }

    func saveMovieDetails(_ data: MovieDetails) async throws {
        saveDetailsCalled = true
        details[data.id] = data
    }
}
