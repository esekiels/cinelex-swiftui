//
//  HomeBackdropCarousel.swift
//  Home
//
//  Created by Esekiel Surbakti on 10/02/26.
//

import Common
import Design
import Model
import Kingfisher

struct HomeBackdropCarousel: View {
    
    let title: String
    let data: [Movie]
    
    var body: some View {
        GeometryReader { geometry in
            content(geometry)
        }
        .frame(height: UIScreen.main.bounds.width * 0.75 * (9 / 16) + 70)
    }
    
    private func content(_ geometry: GeometryProxy) -> some View {
        VStack(alignment: .leading, spacing: geometry.size.height * 0.02) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
            carousel(geometry)
        }
        .padding(.leading, geometry.size.width * 0.04)
    }
    
    private func carousel(_ geometry: GeometryProxy) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack {
                ForEach(data) { movie in
                    backdropCard(movie, geometry: geometry)
                }
            }
        }.scrollTargetLayout()
    }
    
    private func backdropCard(_ movie: Movie, geometry: GeometryProxy) -> some View {
        let cardWidth = geometry.size.width * 0.75
        let cardHeight = cardWidth * (9 / 16)
        
        return VStack(alignment: .leading, spacing: 8) {
            KFImage.url(movie.backdropUrl)
                .placeholder { ImagePlaceholder(16 / 9) }
                .resizable()
                .loadDiskFileSynchronously()
                .cacheOriginalImage()
                .scaleFactor(UIScreen.main.scale)
                .fade(duration: 0.2)
                .aspectRatio(16 / 9, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(movie.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .lineLimit(1)
        }
        .frame(width: cardWidth, height: cardHeight)
        .buttonStyle(.plain)
    }
}

#Preview("Light") {
    HomeBackdropCarousel(title: LocalizeConstant.popular, data: Movie.stubs)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomeBackdropCarousel(title: LocalizeConstant.popular, data: Movie.stubs)
        .preferredColorScheme(.dark)
}
