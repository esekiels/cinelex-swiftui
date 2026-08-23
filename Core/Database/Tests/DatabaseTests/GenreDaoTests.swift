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

    @Test func saveAndGet() async throws {
        let sut = try makeSUT()
        let genres = Genre.stubs

        try await sut.save(genres)
        let result = try await sut.get()

        for genre in genres {
            #expect(result.contains { $0.id == genre.id && $0.name == genre.name })
        }
    }

    @Test func saveUpsertsRatherThanDuplicating() async throws {
        let sut = try makeSUT()

        try await sut.save([Genre(id: 9001, name: "Original")])
        try await sut.save([Genre(id: 9001, name: "Renamed")])
        let result = try await sut.get()

        #expect(result.filter { $0.id == 9001 }.count == 1)
        #expect(result.first { $0.id == 9001 }?.name == "Renamed")
    }

    private func makeSUT() throws -> GenreDao {
        GenreDao(container: TestContainer.shared)
    }
}
