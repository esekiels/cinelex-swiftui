//
//  HomeScreen.swift
//  Home
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Common
import Data
import Datastore
import Design
import Model
import Details

enum CarouselStyle {
    case poster
    case backdrop
}

public struct HomeView: View {

    @State private var viewModel: HomeViewModel
    @Environment(UserPreferences.self) private var preferences
    @Environment(\.detailsFactory) private var factory

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            content
                .navigationTitle(LocalizeConstant.app)
                .toolbar { toolbarItems }
                .task { viewModel.fetchMovies() }
                .refreshable { viewModel.fetchMovies() }
                .navigationDestination(for: Movie.self) { movie in
                    if let factory {
                        factory.makeDetailsView(movie.id)
                    }
                }
        }
    }
}

private extension HomeView {
    
    @ViewBuilder
    var content: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                switch viewModel.state.uiState {
                case .idle:
                    HomePosterCarousel(
                        title: LocalizeConstant.nowPlaying,
                        data: viewModel.state.nowPlaying
                    )
                    HomeBackdropCarousel(
                        title: LocalizeConstant.popular,
                        data: viewModel.state.popular
                    )
                    HomePosterCarousel(
                        title: LocalizeConstant.topRated,
                        data: viewModel.state.topRated
                    )
                    HomeBackdropCarousel(
                        title: LocalizeConstant.upcoming,
                        data: viewModel.state.upcoming
                    )
                default:
                    HomeSkeletonView(style: .poster)
                    HomeSkeletonView(style: .backdrop)
                    HomeSkeletonView(style: .poster)
                    HomeSkeletonView(style: .backdrop)
                }
            }
            .padding(.vertical, 16)
        }
    }

    @ToolbarContentBuilder
    var toolbarItems: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            @Bindable var preferences = preferences
            HStack(spacing: 16) {
                Menu {
                    Picker("Language", selection: $preferences.locale) {
                        ForEach(AppLocale.allCases, id: \.self) { option in
                            Label(option.title, systemImage: option.icon)
                                .tag(option)
                        }
                    }
                } label: {
                    Image(systemName: preferences.locale.icon)
                        .accessibilityLabel("localeIcon")
                }
                Menu {
                    Picker("Theme", selection: $preferences.theme) {
                        ForEach(AppTheme.allCases, id: \.self) { option in
                            Label(option.title, systemImage: option.icon)
                                .tag(option)
                        }
                    }
                } label: {
                    Image(systemName: preferences.theme.icon)
                        .accessibilityLabel("themeIcon")
                }
            }
        }
    }
}

#Preview("Light") {
    HomeView(
        viewModel: HomeViewModel(
            repository: FakeMovieRepository()
        )
    )
    .environment(UserPreferences())
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeView(
        viewModel: HomeViewModel(
            repository: FakeMovieRepository()
        )
    )
    .environment(UserPreferences())
    .preferredColorScheme(.dark)
}
