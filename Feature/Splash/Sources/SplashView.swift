//
//  SplashView.swift
//  Splash
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Design
import Common

public struct SplashView: View {

    private let onFinish: () -> Void

    public init(onFinish: @escaping () -> Void) {
        self.onFinish = onFinish
    }

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
            onFinish()
        }
    }

    private func content(width: CGFloat, height: CGFloat) -> some View {
        Image.module("Cinelex")
            .resizable()
            .scaledToFit()
            .frame(width: width * 0.25)
            .accessibilityLabel("splashIcon")
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0.0)
            .frame(width: width, height: height)
            .background(Color.colorPrimary)
            .accessibilityIdentifier("splashScreen")
    }
}
