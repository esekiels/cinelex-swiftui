//
//  DetailsViewModel.swift
//  Details
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Data
import Common
import Model

@Observable
@MainActor
public class DetailsViewModel {

    private(set) var state = DetailsState()

    private let repository: MovieRepositoryProtocol
    private let movieId: Int

    public init(repository: MovieRepositoryProtocol, movieId: Int) {
        self.repository = repository
        self.movieId = movieId
    }

    func fetchDetails() {
        state.uiState = .loading

        Task {
            for await result in repository.fetchMovieDetails(movieId) {
                consume(result)
            }
        }
    }
}

private extension DetailsViewModel {

    func consume(_ result: Result<MovieDetails, CinelexError>) {
        switch result {
        case .success(let data):
            state.movie = data
            state.uiState = .idle
        case .failure(let error):
            state.uiState = state.movie == nil ? .error(error) : .idle
        }
    }
}
