//
//  HomeSkeletonView.swift
//  Home
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Design

struct HomeSkeletonView: View {
    
    let style: CarouselStyle
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titlePlaceholder
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { _ in
                        skeletonCard
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private var titlePlaceholder: some View {
        skeletonRect(width: 150, height: 30)
            .padding(.leading, 16)
    }
    
    @ViewBuilder
    private var skeletonCard: some View {
        switch style {
        case .poster:
            skeletonRect(width: 120, height: 180)
        case .backdrop:
            skeletonRect(ratio: 9 / 16)
        }
    }
    
    private func skeletonRect(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.gray.opacity(0.3))
            .frame(width: width, height: height)
            .shimmerEffect()
    }
    
    private func skeletonRect(ratio: CGFloat) -> some View {
        GeometryReader { _ in
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray.opacity(0.3))
                .shimmerEffect()
        }
        .frame(width: UIScreen.main.bounds.width * 0.75)
        .aspectRatio(1 / ratio, contentMode: .fit)
    }
}

#Preview("Backdrop") {
    HomeSkeletonView(style: .backdrop)
}

#Preview("Poster") {
    HomeSkeletonView(style: .poster)
}
