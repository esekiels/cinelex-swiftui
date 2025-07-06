//
//  SplashView.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Base

public struct SplashView: View {
    
    // MARK: - Properties
    
    @EnvironmentObject private var cordinator: AppCordinator
    
    @State private var isVisible: Bool = false
    
    public init() {}
    
    // MARK: - Views
    
    public var body: some View {
        bodySection
            .onAppear {
                withAnimation(.easeOut(duration: 1.0)) {
                    isVisible = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    cordinator.currentRoute = .main
                }
            }
    }
    
    private var bodySection: some View {
        GeometryReader { geometry in
            VStack(spacing: geometry.size.height * 0.05) {
                Image.cinelexIcon
                    .resizable()
                    .scaledToFit()
                    .accessibilityLabel("Splash Icon")
                    .frame(width: geometry.size.width * 0.3)
                    .scaleEffect(isVisible ? 1.0 : 0.8)
                    .opacity(isVisible ? 1.0 : 0.0)
                
                Text("Cinelex")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .opacity(isVisible ? 1.0 : 0.0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.ignoresSafeArea())
        }
    }
}
