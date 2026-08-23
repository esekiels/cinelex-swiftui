//
//  HomeViewModel.swift
//  Home
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Data
import Common
import Model

@Observable
@MainActor
public class HomeViewModel {

    private(set) var state = HomeState()

    private let repository: MovieRepositoryProtocol

    public init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func fetchMovies() {
        state.uiState = .loading

        consume(repository.fetchNowPlaying()) { self.state.nowPlaying = $0 }
        consume(repository.fetchPopular()) { self.state.popular = $0 }
        consume(repository.fetchUpcoming()) { self.state.upcoming = $0 }
        consume(repository.fetchTopRated()) { self.state.topRated = $0 }
    }
}

private extension HomeViewModel {
    
    var hasCarousels: Bool {
        !state.nowPlaying.isEmpty || !state.popular.isEmpty
            || !state.upcoming.isEmpty || !state.topRated.isEmpty
    }
    
    func consume(
        _ stream: DataStream<[Movie]>,
        assign: @escaping ([Movie]) -> Void
    ) {
        Task {
            for await result in stream {
                switch result {
                case .success(let items):
                    assign(items)
                    state.uiState = .idle
                case .failure(let error):
                    if hasCarousels {
                        state.uiState = .idle
                    } else {
                        state.uiState = .error(error)
                    }
                }
            }
        }
    }
}
