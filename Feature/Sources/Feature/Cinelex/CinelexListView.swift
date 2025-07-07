//
//  CinelexListView.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Base
import Model

struct CinelexListView: View {
    
    // MARK: - Properties
    
    @StateObject private var viewModel = CinelexListViewModel()
    
    @EnvironmentObject private var navigation: CinelexNavigation
    
    // MARK: - Views
    
    var body: some View {
        bodySection
            .navigationTitle("Movies")
            .alert("Error", isPresented: $viewModel.isAlertPresented, actions: {
                Button(role: .cancel, action: {}, label: {
                    Text("OK")
                })
            }, message: {
                Text(viewModel.errorMessage)
            })
    }
    
    private var bodySection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                movieSection(title: "Now Playing", state: viewModel.nowPlayingState, isPoster: true)
                movieSection(title: "Upcoming", state: viewModel.upcomingState, isPoster: false)
                movieSection(title: "Top Rated", state: viewModel.topRatedState, isPoster: false)
                movieSection(title: "Popular", state: viewModel.popularState, isPoster: false)
            }
        }
    }
    
    @ViewBuilder
    private func movieSection(title: String, state: ViewModelState<[Movie]>, isPoster: Bool) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            switch state {
            case .success(let movies):
                if movies.isEmpty {
                    EmptyView()
                } else {
                    if isPoster {
                        CinelixPosterCarouselView(title: title, movies: movies)
                            .environmentObject(navigation)
                    } else {
                        CinelixBackdropCarouselView(title: title, movies: movies)
                            .environmentObject(navigation)
                    }
                }
            default:
                EmptyView()
            }
        }
        .listRowInsets(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
    }
}
