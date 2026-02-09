//
//  ContentView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Design
import Navigation
import Splash

struct ContentView: View {
    
    @Environment(CinelexCoordinator.self) private var coordinator
    
    var body: some View {
        Group {
            switch coordinator.route {
            case .splash:
                SplashView()
            case .home:
                EmptyView()
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
