//
//  SearchView.swift
//  Search
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import SwiftUI
import Kingfisher
import Model
import Design
import Common
import Data

public struct SearchView: View {

    @State private var viewModel: SearchViewModel
    @Environment(\.detailsFactory) private var factory

    public init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle(LocalizeConstant.search)
                .searchable(
                    text: $viewModel.query,
                    prompt: Text(LocalizeConstant.searchPrompt)
                )
                .task {
                    viewModel.load()
                }
                .navigationDestination(for: Int.self) { movieId in
                    factory?.makeDetailsView(movieId)
                }
        }
    }
}

private extension SearchView {

    @ViewBuilder
    var content: some View {
        switch viewModel.state.uiState {
        case .idle:
            if viewModel.query.isEmpty {
                recommendationList
            } else if viewModel.state.movies.isEmpty {
                ContentUnavailableView.search(text: viewModel.query)
            } else {
                movieList
            }
        case .loading:
            ProgressView()
        case .error:
            EmptyView()
        }
    }

    // MARK: - Recommendations

    var recommendationList: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                Text(LocalizeConstant.recommendations)
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                ForEach(viewModel.state.recommendations) { movie in
                    recommendationRow(movie)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    func recommendationRow(_ movie: Movie) -> some View {
        NavigationLink(value: movie.id) {
            HStack(alignment: .center, spacing: 12) {
                KFImage.url(movie.backdropUrl)
                    .placeholder { ImagePlaceholder(16 / 9) }
                    .resizable()
                    .loadDiskFileSynchronously()
                    .cacheOriginalImage()
                    .scaleFactor(UIScreen.main.scale)
                    .fade(duration: 0.2)
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .frame(width: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(movie.title)
                    .font(.subheadline)
                    .bold()
                    .lineLimit(2)
                    .foregroundStyle(.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.textSecondary)
                    .accessibilityLabel("moreIcon")
            }
            .padding(.horizontal, 16)
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("MovieRecommendationRow")
    }

    // MARK: - Movie List

    var movieList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.state.movies) { movie in
                    movieRow(movie)
                        .onAppear {
                            viewModel.loadMoreIfNeeded(current: movie)
                        }
                }

                if viewModel.state.isLoadingMore {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Movie Row

    func movieRow(_ movie: Movie) -> some View {
        NavigationLink(value: movie.id) {
            HStack(alignment: .center, spacing: 12) {
                posterImage(movie)
                movieInfo(movie)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.headline)
                    .foregroundStyle(.textSecondary)
                    .accessibilityLabel("moreIcon")
            }
        }
        .buttonStyle(.plain)
        .accessibilityIdentifier("MovieRow")
    }

    func posterImage(_ movie: Movie) -> some View {
        KFImage.url(movie.posterUrl)
            .placeholder { ImagePlaceholder(2 / 3) }
            .resizable()
            .loadDiskFileSynchronously()
            .cacheOriginalImage()
            .scaleFactor(UIScreen.main.scale)
            .fade(duration: 0.2)
            .aspectRatio(2 / 3, contentMode: .fit)
            .frame(width: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    func movieInfo(_ movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.headline)
                .lineLimit(2)
                .foregroundStyle(.textPrimary)

            HStack(spacing: 8) {
                Text(movie.releaseDate.isEmpty ? "n/a" : String(movie.releaseDate.prefix(4)))
                    .font(.subheadline)
                    .foregroundStyle(.textSecondary)

                Text("•")
                    .font(.caption)
                    .foregroundStyle(.textSecondary)

                rating(movie)
            }

            genreTags(movie)
        }
    }

    func rating(_ movie: Movie) -> some View {
        HStack(spacing: 4) {
            Image(systemName: "star.fill")
                .font(.caption)
                .foregroundStyle(.yellow)
                .accessibilityLabel("ratingIcon")

            Text(movie.rating)
                .font(.subheadline)
                .foregroundStyle(.textPrimary)

            Text("(\(movie.voteCount))")
                .font(.caption)
                .foregroundStyle(.textSecondary)
        }
    }

    func genreTags(_ movie: Movie) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                if let genres = movie.genres, !genres.isEmpty {
                    ForEach(genres, id: \.id) { genre in
                        genreTag(genre.name)
                    }
                } else {
                    genreTag("n/a", isPlaceholder: true)
                }
            }
        }
    }

    func genreTag(_ name: String, isPlaceholder: Bool = false) -> some View {
        Text(name)
            .font(.caption)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(isPlaceholder ? Color.gray.opacity(0.2) : Color.blue.opacity(0.2))
            .foregroundStyle(isPlaceholder ? .textSecondary : .textPrimary)
            .clipShape(Capsule())
    }
}

// MARK: - Previews

#Preview("Light") {
    SearchView(
        viewModel: SearchViewModel(
            movieRepository: FakeMovieRepository(),
            genreRepository: FakeGenreRepository()
        )
    )
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    SearchView(
        viewModel: SearchViewModel(
            movieRepository: FakeMovieRepository(),
            genreRepository: FakeGenreRepository()
        )
    )
    .preferredColorScheme(.dark)
}
