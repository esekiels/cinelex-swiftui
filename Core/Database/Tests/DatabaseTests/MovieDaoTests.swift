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

struct MovieDaoTests {
    
    @Test func saveAndFetch() async throws {
        let sut = try makeSUT()
        let movies = Movie.stubs
        
        try await sut.save(movies, category: "nowPlaying")
        let result = try await sut.fetch("nowPlaying")
        
        #expect(result.count == movies.count)
        #expect(result[0].id == movies[0].id)
        #expect(result[0].title == movies[0].title)
    }
    
    @Test func deleteAll() async throws {
        let sut = try makeSUT()
        
        try await sut.save(Movie.stubs, category: "nowPlaying")
        try await sut.save(Movie.stubs, category: "popular")
        try await sut.deleteAll()
        
        let nowPlaying = try await sut.fetch("nowPlaying")
        let popular = try await sut.fetch("popular")
        
        #expect(nowPlaying.isEmpty)
        #expect(popular.isEmpty)
    }
    
    private func makeSUT() throws -> MovieDao {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: MovieEntity.self, configurations: config)
        return MovieDao(container: container)
    }
}
