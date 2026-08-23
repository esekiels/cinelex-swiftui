//
//  MovieDaoTests.swift
//  Database
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Testing
import SwiftData
@testable import Database
import Model

@Suite struct MovieDaoTests {

    @Test func saveAndGet() async throws {
        let container = try makeContainer()
        let sut = MovieDao(category: "nowPlaying", container: container)
        let movies = Movie.stubs

        try await sut.save(movies)
        let result = try await sut.get()

        #expect(result.count == movies.count)
        #expect(result[0].id == movies[0].id)
        #expect(result[0].title == movies[0].title)
    }

    @Test func getIsScopedToItsCategory() async throws {
        let container = try makeContainer()
        let nowPlaying = MovieDao(category: "nowPlaying", container: container)
        let popular = MovieDao(category: "popular", container: container)

        try await nowPlaying.save(Movie.stubs)

        #expect(try await nowPlaying.get().count == Movie.stubs.count)
        #expect(try await popular.get().isEmpty)
    }

    @Test func saveAndGetDetails() async throws {
        let sut = MovieDao(container: try makeContainer())

        try await sut.saveDetails(MovieDetails.stub)
        let result = try await sut.getDetails(MovieDetails.stub.id)

        #expect(result.id == MovieDetails.stub.id)
        #expect(result.title == MovieDetails.stub.title)
        #expect(result.genres.count == MovieDetails.stub.genres.count)
    }

    @Test func getDetailsThrowsWhenNothingCached() async throws {
        let sut = MovieDao(container: try makeContainer())

        await #expect(throws: DatabaseError.self) {
            _ = try await sut.getDetails(999_999)
        }
    }

    @Test func saveDetailsReplacesRatherThanDuplicating() async throws {
        let sut = MovieDao(container: try makeContainer())

        try await sut.saveDetails(MovieDetails.stub)
        try await sut.saveDetails(MovieDetails.stub)
        let result = try await sut.getDetails(MovieDetails.stub.id)

        #expect(result.id == MovieDetails.stub.id)
    }

    private func makeContainer() throws -> ModelContainer {
        TestContainer.shared
    }
}
