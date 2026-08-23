//
//  ContentView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Design
import Splash
import Home

struct ContentView: View {

    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView { showSplash = false }
            } else {
                CinelexTabView()
            }
        }
    }
}

#Preview("Light") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    ContentView()
        .preferredColorScheme(.dark)
}
