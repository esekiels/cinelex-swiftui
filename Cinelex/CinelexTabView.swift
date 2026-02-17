//
//  CinelexTabView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import SwiftUI
import Home
import Search
import Common

struct CinelexTabView: View {
    
    @Environment(\.factory) private var factory
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(viewModel: factory.injectHomeViewModel())
                .tag(0)
                .tabItem {
                    Label(LocalizeConstant.home, systemImage: "house.fill")
                }
            SearchView(viewModel: factory.injectSearchViewModel())
                .tag(0)
                .tabItem {
                    Label(LocalizeConstant.search, systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    CinelexTabView()
        .preferredColorScheme(.light)
}
