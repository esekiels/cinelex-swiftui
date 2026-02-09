//
//  MovieService.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

public protocol MovieServiceProtocol: Sendable {
    
    func fetchNowPlaying() async throws
}

public final class MovieService: MovieServiceProtocol {
    
    private let apiManager: ApiManager
    private let baseUrl: String
    private let token: String
    
    public init(
        apiManager: ApiManager = .shared,
        baseUrl: String = ApiEnvironment.baseUrl,
        token: String = ApiEnvironment.token
    ) {
        self.apiManager = apiManager
        self.baseUrl = baseUrl
        self.token = token
    }
    
    public func fetchNowPlaying() async throws {
        try await fetchMovies(.nowPlaying)
    }
    
    private func fetchMovies(_ endpoint: ApiConstant) async throws {
        let url = "\(baseUrl)\(endpoint.rawValue)?&includelanguage=en-US&page=1"
        let response: MovieResponse = try await apiManager.get(url, token: token)
    }
}
