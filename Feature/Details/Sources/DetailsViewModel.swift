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

    private(set) var state: UiState = .loading
    private(set) var movie: MovieDetails?
    private(set) var title: String = ""

    private let repository: MovieRepositoryProtocol
    private let movieId: Int

    public init(repository: MovieRepositoryProtocol, movieId: Int) {
        self.repository = repository
        self.movieId = movieId
    }

    func fetchDetails() {
        state = .loading

        Task {
            for await result in repository.fetchMovieDetails(movieId) {
                switch result {
                case .success(let data):
                    title = data.title
                    movie = data
                    state = .idle
                case .failure(let error):
                    if movie == nil {
                        state = .error(error)
                    } else {
                        state = .idle
                    }
                }
            }
        }
    }
}
