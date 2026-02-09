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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(coordinator)
        }
    }
}
