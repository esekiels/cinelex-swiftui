//
//  CinelexApp.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Datastore
import Design
import Navigation

@main
struct CinelexApp: App {

    @State private var coordinator = CinelexCoordinator()
    @State private var preferences = UserPreferences()
    private let factory = CinelexDIFactory()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(coordinator)
                .environment(preferences)
                .environment(\.factory, factory)
                .environment(\.homeFactory, factory)
                .environment(\.searchFactory, factory)
                .preferredColorScheme(preferences.theme.colorScheme)
                .environment(\.locale, preferences.locale.locale)
        }
    }
}
