//
//  ContentView.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Feature

struct ContentView: View {
    
    // MARK: - Properties
    
    @StateObject private var cordinator = AppCordinator()
    
    var body: some View {
        bodySection
    }
    
    @ViewBuilder
    private var bodySection: some View {
        switch cordinator.currentRoute {
        case .splash:
            SplashView()
                .environmentObject(cordinator)
        case .main:
            CinelexView()
                .environmentObject(cordinator)
        }
    }
}

#Preview {
    ContentView()
}
