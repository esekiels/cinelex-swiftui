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
    private var genres: [Genre] = []
    private var searchTask: Task<Void, Never>?

    private let movieRepository: MovieRepositoryProtocol
    private let genreRepository: GenreRepositoryProtocol

    public init(movieRepository: MovieRepositoryProtocol, genreRepository: GenreRepositoryProtocol) {
        self.movieRepository = movieRepository
        self.genreRepository = genreRepository
    }

    func load() {
        Task { for await items in movieRepository.fetchPopular() { recommendations = items } }
        Task { for await items in genreRepository.fetchGenres() { genres = items } }
    }

    func loadMoreIfNeeded(current movie: Movie) {
        guard movie.id == movies.last?.id,
              currentPage < totalPages,
              !isLoadingMore else { return }

        Task {
            isLoadingMore = true
            do {
                let response = try await movieRepository.searchMovies(query: query, page: currentPage + 1)
                movies.append(contentsOf: mapGenres(response.results))
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
            let response = try await movieRepository.searchMovies(query: query, page: 1)
            movies = mapGenres(response.results)
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

    private func mapGenres(_ movies: [Movie]) -> [Movie] {
        movies.map { movie in
            var movie = movie
            movie.genres = genres.filter { movie.genreIds?.contains($0.id) == true }
            return movie
        }
    }
}
