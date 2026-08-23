//
//  CinelexApp.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Datastore
import Design

@main
struct CinelexApp: App {

    @State private var preferences = UserPreferences()
    private let factory = CinelexDIFactory()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(preferences)
                .environment(\.factory, factory)
                .environment(\.detailsFactory, factory)
                .preferredColorScheme(preferences.theme.colorScheme)
                .environment(\.locale, preferences.locale.locale)
        }
    }
}
