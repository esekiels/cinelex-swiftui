//
//  GenreService.swift
//  Network
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Model

public protocol GenreServiceProtocol: Sendable {
    
    func fetchGenres() async throws -> [Genre]
}

public final class GenreService: GenreServiceProtocol {
        
    private let apiManager: ApiManagerProtocol
    
    public init(apiManager: ApiManagerProtocol = ApiManager.shared) {
        self.apiManager = apiManager
    }
    
    public func fetchGenres() async throws -> [Genre] {
        let url = "\(ApiEnvironment.baseUrl)\(ApiConstant.genres.rawValue)?language=en-US"
        let response: GenreResponse = try await apiManager.get(url, token: ApiEnvironment.token)
        return response.results
    }
}
