//
//  FakeGenreRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Model

public final class FakeGenreRepository: GenreRepositoryProtocol {
    
    public init() {}
    
    public func fetchGenres() async throws -> [Genre] {
        Genre.stubs
    }
}
