//
//  Shimmer.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI

public struct Shimmer: ViewModifier {
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)

    private let gradientColors: [Color] = [
        Color.white.opacity(0.4),
        Color.gray.opacity(0.7),
        Color.white.opacity(0.4)
    ]

    public func body(content: Content) -> some View {
        content
            .redacted(reason: .placeholder)
            .overlay(
                LinearGradient(colors: gradientColors, startPoint: startPoint, endPoint: endPoint)
                    .mask(content)
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: false)) {
                    startPoint = .init(x: 1, y: 1)
                    endPoint = .init(x: 2.2, y: 2.2)
                }
            }
    }
}

#Preview() {
    Color.gray
        .frame(width: 96, height: 96)
        .cornerRadius(8)
        .shimmerEffect()
        .padding()
}
