//
//  HomeScreen.swift
//  Home
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Common
import Data
import Design
import Model
import Details

public struct HomeView: View {
    
    @State private var viewModel: HomeViewModel
    @Environment(\.homeFactory) private var factory
    
    public init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    section(
                        state: viewModel.nowPlayingState,
                        style: .poster
                    ) {
                        HomePosterCarousel(
                            title: LocalizeConstant.nowPlaying,
                            data: viewModel.nowPlaying
                        )
                    }
                    
                    section(
                        state: viewModel.popularState,
                        style: .backdrop
                    ) {
                        HomeBackdropCarousel(
                            title: LocalizeConstant.popular,
                            data: viewModel.popular
                        )
                    }
                    
                    section(
                        state: viewModel.topRatedState,
                        style: .poster
                    ) {
                        HomePosterCarousel(
                            title: LocalizeConstant.topRated,
                            data: viewModel.topRated
                        )
                    }
                    
                    section(
                        state: viewModel.upcomingState,
                        style: .backdrop
                    ) {
                        HomeBackdropCarousel(
                            title: LocalizeConstant.upcoming,
                            data: viewModel.upcoming
                        )
                    }
                }
                .padding(.vertical, 16)
            }
            .task {
                await viewModel.refresh()
            }
            .navigationTitle(LocalizeConstant.app)
            .refreshable {
                await viewModel.refresh()
            }
            .navigationDestination(for: Movie.self) { movie in
                if let factory {
                    factory.makeDetailsView(movie.id)
                }
            }
        }
    }
    
    @ViewBuilder
    private func section<Content: View>(
        state: UiState,
        style: CarouselStyle,
        @ViewBuilder content: () -> Content
    ) -> some View {
        switch state {
        case .idle:
            content()
        default:
            HomeSkeletonView(style: style)
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
    .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeView(
        viewModel: HomeViewModel(
            repository: FakeHomeRepository()
        )
    )
    .preferredColorScheme(.dark)
}
