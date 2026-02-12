//
//  CinelexApp.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Design
import Navigation

@main
struct CinelexApp: App {
    
    @State private var coordinator = CinelexCoordinator()
    private let factory = CinelexDIFactory()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(coordinator)
                .environment(\.factory, factory)
                .environment(\.homeFactory, factory)
        }
    }
}
