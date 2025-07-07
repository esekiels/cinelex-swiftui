//
//  CinelixBackdropCard.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Kingfisher
import Model
import Base

struct CinelixBackdropCard: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage.url(movie.backDropUrl)
                .placeholder({
                    Color.gray
                        .aspectRatio(16 / 9, contentMode: .fit)
                        .cornerRadius(8)
                        .shimmerEffect()
                })
                .resizable()
                .cacheMemoryOnly()
                .fade(duration: 0.25)
                .loadDiskFileSynchronously()
                .aspectRatio(16 / 9, contentMode: .fit)
                .cornerRadius(8)
                .shadow(radius: 4)
            Text(movie.title)
        }
        .lineLimit(1)
    }
}

#Preview {
    CinelixBackdropCard(movie: Movie.stubbedMovie)
}
