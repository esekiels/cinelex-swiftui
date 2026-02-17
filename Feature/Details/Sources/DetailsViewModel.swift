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
public class DetailsViewModel: BaseViewModel {
    
    private(set) var state: UiState = .loading
    private(set) var movie: MovieDetails?
    private(set) var title: String = ""
    
    private let repository: DetailsRepositoryProtocol
    private let movieId: Int
    
    public init(repository: DetailsRepositoryProtocol, movieId: Int) {
        self.repository = repository
        self.movieId = movieId
    }
    
    func fetchDetails() {
        state = .loading
        
        Task {
            do {
                let data = try await repository.fetchDetails(movieId)
                title = data.title
                movie = data
                state = .idle
            } catch {
                let cinelexError = handleError(error)
                state = .error(cinelexError)
            }
        }
    }
}
