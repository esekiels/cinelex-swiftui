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
@MainActor
public class SearchViewModel {

    var query: String = "" {
        didSet {
            handleQueryChange()
        }
    }

    private(set) var state = SearchState()

    private var currentPage: Int = 1
    private var totalPages: Int = 1
    private var genres: [Genre] = []
    private var searchTask: Task<Void, Never>?

    private let movieRepository: MovieRepositoryProtocol
    private let genreRepository: GenreRepositoryProtocol

    public init(movieRepository: MovieRepositoryProtocol, genreRepository: GenreRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.genreRepository = genreRepository
    }

    func load() {
        Task {
            for await result in movieRepository.fetchPopular() {
                if case .success(let items) = result { state.recommendations = items }
            }
        }
        Task {
            for await result in genreRepository.fetchGenres() {
                if case .success(let items) = result { genres = items }
            }
        }
    }

    func loadMoreIfNeeded(current movie: Movie) {
        guard movie.id == state.movies.last?.id,
              currentPage < totalPages,
              !state.isLoadingMore else { return }

        Task {
            state.isLoadingMore = true
            do {
                let response = try await movieRepository.searchMovies(query: query, page: currentPage + 1)
                state.movies.append(contentsOf: mapGenres(response.results))
                currentPage = response.page
                totalPages = response.totalPages
            } catch {
                state.uiState = .error(error.toCinelexError())
            }
            state.isLoadingMore = false
        }
    }
}

private extension SearchViewModel {

    func handleQueryChange() {
        searchTask?.cancel()

        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            state.movies = []
            state.uiState = .idle
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

    func search() async {
        state.uiState = .loading
        currentPage = 1
        totalPages = 1

        do {
            let response = try await movieRepository.searchMovies(query: query, page: 1)
            state.movies = mapGenres(response.results)
            currentPage = response.page
            totalPages = response.totalPages
            state.uiState = .idle
        } catch {
            guard !Task.isCancelled else {
                return
            }
            state.uiState = .error(error.toCinelexError())
        }
    }

    func mapGenres(_ movies: [Movie]) -> [Movie] {
        movies.map { movie in
            var movie = movie
            movie.genres = genres.filter { movie.genreIds?.contains($0.id) == true }
            return movie
        }
    }
}
