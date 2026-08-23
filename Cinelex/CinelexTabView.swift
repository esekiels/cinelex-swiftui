//
//  CinelexTabView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import SwiftUI
import Datastore
import Home
import Search
import Common
import Design

struct CinelexTabView: View {

    @Environment(\.factory) private var factory
    @Environment(UserPreferences.self) private var preferences

    var body: some View {
        TabView {
            HomeView(viewModel: factory.injectHomeViewModel())
                .tabItem {
                    Label(LocalizeConstant.home, systemImage: "house.fill")
                }
            SearchView(viewModel: factory.injectSearchViewModel())
                .tabItem {
                    Label(LocalizeConstant.search, systemImage: "magnifyingglass")
                }
        }
        .tint(Color.colorPrimary)
        .id(preferences.locale)
    }
}
