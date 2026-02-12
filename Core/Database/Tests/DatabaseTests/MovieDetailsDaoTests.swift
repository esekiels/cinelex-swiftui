//
//  MovieDetailsDaoTests.swift
//  Database
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Testing
import SwiftData
import Model
@testable import Database

@Suite struct MovieDetailsDaoTests {
    
    private func makeSUT() throws -> MovieDetailsDao {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(
            for: MovieDetailsEntity.self,
            configurations: config
        )
        return MovieDetailsDao(container: container)
    }
    
    @Test func saveAndFetch() async throws {
        let sut = try makeSUT()
        let movie = MovieDetails.stub
        
        try await sut.save(movie)
        let result = try await sut.fetch(movie.id)
        
        #expect(result != nil)
        #expect(result?.id == movie.id)
        #expect(result?.title == movie.title)
        #expect(result?.genres.count == movie.genres.count)
    }
    
    @Test func delete() async throws {
        let sut = try makeSUT()
        let movie = MovieDetails.stub
        
        try await sut.save(movie)
        try await sut.delete(movie.id)
        let result = try await sut.fetch(movie.id)
        
        #expect(result == nil)
    }
}
