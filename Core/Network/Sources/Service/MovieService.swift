//
//  MovieService.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation
import Model

public protocol MovieServiceProtocol: Sendable {
    
    func fetchNowPlaying() async throws -> [Movie]
    func fetchUpcoming() async throws -> [Movie]
    func fetchTopRated() async throws -> [Movie]
    func fetchPopular() async throws -> [Movie]
}

public final class MovieService: MovieServiceProtocol {
    
    private let apiManager: ApiManager
    
    public init (apiManager: ApiManager = .shared) {
        self.apiManager = apiManager
    }
    
    public func fetchNowPlaying() async throws -> [Movie] {
        try await fetchMovies(.nowPlaying)
    }
    
    public func fetchUpcoming() async throws -> [Movie] {
        try await fetchMovies(.upcoming)
    }
    
    public func fetchTopRated() async throws -> [Movie] {
        try await fetchMovies(.topRated)
    }
    
    public func fetchPopular() async throws -> [Movie] {
        try await fetchMovies(.popular)
    }
    
    private func fetchMovies(_ endpoint: ApiConstant) async throws -> [Movie] {
        let url = "\(ApiEnvironment.baseUrl)\(endpoint.rawValue)?&includelanguage=en-US&page=1"
        let response: MovieResponse = try await apiManager.get(url, token: ApiEnvironment.token)
        return response.results
    }
}
