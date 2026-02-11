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
    
    private(set) var nowPlayingState: UiState = .loading
    private(set) var popularState: UiState = .loading
    private(set) var upcomingState: UiState = .loading
    private(set) var topRatedState: UiState = .loading
    
    private(set) var nowPlaying: [Movie] = []
    private(set) var popular: [Movie] = []
    private(set) var upcoming: [Movie] = []
    private(set) var topRated: [Movie] = []
    
    private let repository: HomeRepositoryProtocol
    
    public init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }
    
    func refresh() async {
        await fetchAllMovies()
    }
    
    private func fetchAllMovies() async {
        guard nowPlayingState.isLoading else {
            return
        }
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchNowPlaying() }
            group.addTask { await self.fetchPopular() }
            group.addTask { await self.fetchUpcoming() }
            group.addTask { await self.fetchTopRated() }
        }
    }
    
    private func fetchNowPlaying() async {
        await fetchMovies(
            updateState: { self.nowPlayingState = $0 },
            updateData: { self.nowPlaying = $0 },
            fetcher: repository.fetchNowPlaying
        )
    }
    
    private func fetchPopular() async {
        await fetchMovies(
            updateState: { self.popularState = $0 },
            updateData: { self.popular = $0 },
            fetcher: repository.fetchPopular
        )
    }
    
    private func fetchUpcoming() async {
        await fetchMovies(
            updateState: { self.upcomingState = $0 },
            updateData: { self.upcoming = $0 },
            fetcher: repository.fetchUpcoming
        )
    }
    
    private func fetchTopRated() async {
        await fetchMovies(
            updateState: { self.topRatedState = $0 },
            updateData: { self.topRated = $0 },
            fetcher: repository.fetchTopRated
        )
    }
    
    private func fetchMovies(
        updateState: (UiState) -> Void,
        updateData: ([Movie]) -> Void,
        fetcher: () async throws -> [Movie]
    ) async {
        updateState(.loading)
        
        do {
            let movies = try await fetcher()
            updateData(movies)
            updateState(.idle)
        } catch {
            let cinelexError = handleError(error)
            updateState(.error(cinelexError))
        }
    }
}
