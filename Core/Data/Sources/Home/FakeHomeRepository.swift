//
//  FakeHomeRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 10/02/26.
//

import Model

public final class FakeHomeRepository: HomeRepositoryProtocol {
    
    public init() {}
    
    public func fetchNowPlaying() async throws -> [Movie] {
        Movie.stubs
    }
    
    public func fetchUpcoming() async throws -> [Movie] {
        Movie.stubs
    }
    
    public func fetchPopular() async throws -> [Movie] {
        Movie.stubs
    }
    
    public func fetchTopRated() async throws -> [Movie] {
        Movie.stubs
    }
    
    public func fetchGenres() async {}
}
