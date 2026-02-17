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
