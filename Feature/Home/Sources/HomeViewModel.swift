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
public class HomeViewModel: BaseViewModel {

    private(set) var state: UiState = .loading

    private(set) var nowPlaying: [Movie] = []
    private(set) var popular: [Movie] = []
    private(set) var upcoming: [Movie] = []
    private(set) var topRated: [Movie] = []

    private let repository: HomeRepositoryProtocol

    public init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMovies(forceRefresh: Bool = false) {
        guard !state.isIdle || forceRefresh else {
            return
        }
        state = .loading

        Task {
            do {
                async let nowPlayingResult = repository.fetchNowPlaying()
                async let popularResult = repository.fetchPopular()
                async let upcomingResult = repository.fetchUpcoming()
                async let topRatedResult = repository.fetchTopRated()

                nowPlaying = try await nowPlayingResult
                popular = try await popularResult
                upcoming = try await upcomingResult
                topRated = try await topRatedResult

                await repository.fetchGenres()

                state = .idle
            } catch {
                let cinelexError = handleError(error)
                state = .error(cinelexError)
            }
        }
    }
}
