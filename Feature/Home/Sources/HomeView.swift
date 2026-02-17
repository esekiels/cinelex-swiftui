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

public struct HomeView: View {

    @State private var viewModel: HomeViewModel
    @Environment(UserPreferences.self) private var preferences
    @Environment(\.homeFactory) private var factory

    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    switch viewModel.state {
                    case .idle:
                        HomePosterCarousel(
                            title: LocalizeConstant.nowPlaying,
                            data: viewModel.nowPlaying
                        )
                        HomeBackdropCarousel(
                            title: LocalizeConstant.popular,
                            data: viewModel.popular
                        )
                        HomePosterCarousel(
                            title: LocalizeConstant.topRated,
                            data: viewModel.topRated
                        )
                        HomeBackdropCarousel(
                            title: LocalizeConstant.upcoming,
                            data: viewModel.upcoming
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
            .task {
                viewModel.fetchMovies()
            }
            .navigationTitle(LocalizeConstant.app)
            .toolbar {
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
            .refreshable {
                viewModel.fetchMovies(forceRefresh: true)
            }
            .navigationDestination(for: Movie.self) { movie in
                if let factory {
                    factory.makeDetailsView(movie.id)
                }
            }
        }
    }
}

enum CarouselStyle {
    case poster
    case backdrop
}

#Preview("Light") {
    HomeView(
        viewModel: HomeViewModel(
            repository: FakeHomeRepository()
        )
    )
    .environment(UserPreferences())
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeView(
        viewModel: HomeViewModel(
            repository: FakeHomeRepository()
        )
    )
    .environment(UserPreferences())
    .preferredColorScheme(.dark)
}
