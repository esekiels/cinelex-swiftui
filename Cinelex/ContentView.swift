//
//  ContentView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Design
import Navigation
import Splash
import Home

struct ContentView: View {
    
    @Environment(CinelexCoordinator.self) private var coordinator
    @Environment(\.factory) private var factory
    
    var body: some View {
        Group {
            switch coordinator.route {
            case .splash:
                SplashView()
            case .home:
                CinelexTabView()
            }
        }
    }
}

#Preview("Light") {
    ContentView()
        .environment(CinelexCoordinator())
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .environment(CinelexCoordinator())
        .preferredColorScheme(.dark)
}
