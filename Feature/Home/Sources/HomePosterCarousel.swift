//
//  HomePosterCarousel.swift
//  Home
//
//  Created by Esekiel Surbakti on 10/02/26.
//

import Common
import Design
import Model
import Kingfisher

struct HomePosterCarousel: View {
    
    let title: String
    let data: [Movie]
    
    var body: some View {
        GeometryReader { geometry in
            content(geometry)
        }
        .frame(height: UIScreen.main.bounds.width * 0.4 * (3 / 2) + 60)
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
            LazyHStack(spacing: 16) {
                ForEach(data) { movie in
                    posterCard(movie, geometry: geometry)
                }
            }
        }.scrollTargetLayout()
    }
    
    private func posterCard(_ movie: Movie, geometry: GeometryProxy) -> some View {
        let cardWidth = geometry.size.width * 0.4
        let cardHeight = cardWidth * (3 / 2)
        
        return KFImage.url(movie.posterUrl)
            .placeholder {
                ImagePlaceholder(2 / 3)
            }
            .resizable()
            .loadDiskFileSynchronously()
            .cacheOriginalImage()
            .scaleFactor(UIScreen.main.scale)
            .fade(duration: 0.2)
            .aspectRatio(2 / 3, contentMode: .fit)
            .frame(width: cardWidth, height: cardHeight)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .buttonStyle(.plain)
    }
}

#Preview("Light") {
    HomePosterCarousel(title: LocalizeConstant.nowPlaying, data: Movie.stubs)
        .preferredColorScheme(.light)
}

#Preview("Dark") {
    HomePosterCarousel(title: LocalizeConstant.nowPlaying, data: Movie.stubs)
        .preferredColorScheme(.dark)
}
