//
//  FakeSearchRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Network
import Model

#if DEBUG
public final class FakeSearchRepository: SearchRepositoryProtocol {

    public init() {}

    public func fetchRecommendations() async throws -> [Movie] {
        Movie.stubs
    }

    public func searchMovies(_ query: String, page: Int) async throws -> MovieResponse {
        let filtered = Movie.stubs.filter {
            $0.title.localizedCaseInsensitiveContains(query)
        }
        return MovieResponse(
            page: page,
            results: filtered,
            totalPages: 1,
            totalResults: filtered.count
        )
    }
}
#endif
