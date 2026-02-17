//
//  SplashView.swift
//  Splash
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Navigation
import Design
import Common

public struct SplashView: View {
    
    public init() {}
    
    @Environment(CinelexCoordinator.self) private var coordinator
    @State private var isVisible: Bool = false
    
    public var body: some View {
        GeometryReader { geometry in
            content(width: geometry.size.width, height: geometry.size.height)
        }
        .task {
            withAnimation(.easeOut(duration: 1)) {
                isVisible = true
            }
            
            try? await Task.sleep(for: .seconds(2))
            coordinator.route = .home
        }
    }
    
    private func content(width: CGFloat, height: CGFloat) -> some View {
        VStack(spacing: height * 0.02) {
            Image.module("Cinelex")
                .resizable()
                .scaledToFit()
                .frame(width: width * 0.25)
                .accessibilityLabel("splashIcon")
            Text(LocalizeConstant.app)
                .font(.largeTitle)
                .fontWeight(.bold)
        }
        .scaleEffect(isVisible ? 1.0 : 0.8)
        .opacity(isVisible ? 1.0 : 0.0)
        .frame(width: width, height: height)
        .background(Color(.systemBackground))
        .accessibilityIdentifier("splashScreen")
    }
}
