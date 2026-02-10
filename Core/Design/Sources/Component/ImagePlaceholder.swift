//
//  ImagePlaceholder.swift
//  Design
//
//  Created by Esekiel Surbakti on 10/02/26.
//

public struct ImagePlaceholder: View {
    
    private let aspectRatio: CGFloat
    
    public init(_ aspectRatio: CGFloat) {
        self.aspectRatio = aspectRatio
    }
    
    public var body: some View {
        Color.gray.opacity(0.5)
            .aspectRatio(aspectRatio, contentMode: .fit)
            .cornerRadius(8)
            .shimmerEffect()
    }
}
