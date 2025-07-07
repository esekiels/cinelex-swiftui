//
//  CinelixPoster.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Kingfisher
import Model
import Base

struct CinelixPosterCard: View {
    
    let movie: Movie
    
    var body: some View {
        KFImage.url(movie.posterUrl)
            .placeholder({
                Color.gray
                    .frame(width: 204, height: 306)
                    .cornerRadius(8)
                    .shimmerEffect()
            })
            .resizable()
            .cacheMemoryOnly()
            .fade(duration: 0.25)
            .loadDiskFileSynchronously()
            .frame(width: 204, height: 306)
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8)
            .shadow(radius: 4)
            .padding(4)
    }
}

#Preview {
    CinelixPosterCard(movie: Movie.stubbedMovie)
}
