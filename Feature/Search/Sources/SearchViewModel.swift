//
//  SearchViewModel.swift
//  Search
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Common
import Model
import Data

@Observable
public class SearchViewModel: BaseViewModel {

    var query: String = "" {
        didSet {
            handleQueryChange()
        }
    }

    private(set) var state: UiState = .idle
    private(set) var movies: [Movie] = []
    private(set) var recommendations: [Movie] = []
    private(set) var isLoadingMore: Bool = false

    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var searchTask: Task<Void, Never>?

    private let repository: SearchRepositoryProtocol

    public init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func loadRecommendations() {
        guard recommendations.isEmpty else {
            return
        }

        Task {
            do {
                recommendations = try await repository.fetchRecommendations()
            } catch {
                // no-op
            }
        }
    }

    func loadMoreIfNeeded(current movie: Movie) {
        guard movie.id == movies.last?.id,
              currentPage < totalPages,
              !isLoadingMore else { return }

        Task {
            isLoadingMore = true
            do {
                let response = try await repository.searchMovies(query, page: currentPage + 1)
                movies.append(contentsOf: response.results)
                currentPage = response.page
                totalPages = response.totalPages
            } catch {
                let cinelexError = handleError(error)
                state = .error(cinelexError)
            }
            isLoadingMore = false
        }
    }

    private func handleQueryChange() {
        searchTask?.cancel()

        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            movies = []
            state = .idle
            return
        }

        searchTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else {
                return
            }
            await search()
        }
    }

    private func search() async {
        state = .loading
        currentPage = 1
        totalPages = 1

        do {
            let response = try await repository.searchMovies(query, page: 1)
            movies = response.results
            currentPage = response.page
            totalPages = response.totalPages
            state = .idle
        } catch {
            guard !Task.isCancelled else {
                return
            }
            let cinelexError = handleError(error)
            state = .error(cinelexError)
        }
    }
}
