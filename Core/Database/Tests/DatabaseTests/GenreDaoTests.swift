//
//  GenreDaoTests.swift
//  Database
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Testing
import SwiftData
@testable import Database
import Model

@Suite struct GenreDaoTests {

    @Test func saveAndFetch() async throws {
        let sut = try makeSUT()
        let genres = Genre.stubs

        try await sut.saveGenres(genres)
        let result = try await sut.fetchGenres()

        #expect(result.count == genres.count)
        #expect(result[0].id == genres[0].id)
        #expect(result[0].name == genres[0].name)
    }

    @Test func clearAll() async throws {
        let sut = try makeSUT()

        try await sut.saveGenres(Genre.stubs)
        try await sut.clearAll()

        let genres = try await sut.fetchGenres()

        #expect(genres.isEmpty)
    }

    private func makeSUT() throws -> GenreDaoProtocol {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: GenreEntity.self, configurations: config)
        return GenreDao(container: container)
    }
}
