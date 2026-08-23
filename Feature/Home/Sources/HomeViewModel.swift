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

    private(set) var state: UiState = .loading

    private(set) var nowPlaying: [Movie] = []
    private(set) var popular: [Movie] = []
    private(set) var upcoming: [Movie] = []
    private(set) var topRated: [Movie] = []

    private let repository: MovieRepositoryProtocol

    public init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func fetchMovies() {
        state = .loading

        consume(repository.fetchNowPlaying()) { self.nowPlaying = $0 }
        consume(repository.fetchPopular()) { self.popular = $0 }
        consume(repository.fetchUpcoming()) { self.upcoming = $0 }
        consume(repository.fetchTopRated()) { self.topRated = $0 }
    }

    private var hasCarousels: Bool {
        !nowPlaying.isEmpty || !popular.isEmpty || !upcoming.isEmpty || !topRated.isEmpty
    }

    private func consume(
        _ stream: DataStream<[Movie]>,
        assign: @escaping ([Movie]) -> Void
    ) {
        Task {
            for await result in stream {
                switch result {
                case .success(let items):
                    assign(items)
                    state = .idle
                case .failure(let error):
                    if hasCarousels {
                        state = .idle
                    } else {
                        state = .error(error)
                    }
                }
            }
        }
    }
}
