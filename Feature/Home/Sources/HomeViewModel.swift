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

    private let repository: MovieRepositoryProtocol

    public init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchMovies() {
        state = .loading

        Task { for await items in repository.fetchNowPlaying() { nowPlaying = items } }
        Task { for await items in repository.fetchPopular() { popular = items } }
        Task { for await items in repository.fetchUpcoming() { upcoming = items } }
        Task { for await items in repository.fetchTopRated() { topRated = items } }
        state = .idle
    }
}
