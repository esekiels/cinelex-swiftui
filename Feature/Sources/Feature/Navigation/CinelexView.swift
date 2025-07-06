//
//  CinelexView.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI

public struct CinelexView: View {
    
    // MARK: - Properties
    
    @StateObject private var navigation = CinelexNavigation()
    
    public init() { }
    
    // MARK: - Views
    
    public var body: some View {
        NavigationStack(path: $navigation.path) {
            CinelexListView()
                .environmentObject(navigation)
                .navigationDestination(for: CinelexNavigation.Route.self) { route in
                    switch route {
                    case .detail:
                        EmptyView()
                    }
                }
        }
    }
}
