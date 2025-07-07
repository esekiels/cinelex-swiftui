//
//  CinelixPosterCarouselView.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Model

struct CinelixPosterCarouselView: View {
    
    @EnvironmentObject private var navigation: CinelexNavigation
    let title: String
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top) {
                    ForEach(self.movies) { movie in
                        CinelixPosterCard(movie: movie)
                            .onTapGesture {
                                navigation.navigate(to: .detail(id: movie.id))
                            }.buttonStyle(PlainButtonStyle())
                            .padding(.leading, movie.id == self.movies.first?.id ? 8 : 0)
                            .padding(.trailing, movie.id == self.movies.last?.id ? 8 : 0)
                            .accessibilityAddTraits(.isButton)
                    }
                }
            }
        }
    }
}

#Preview {
    CinelixPosterCarouselView(title: "Now Playing", movies: Movie.stubbedMovies)
        .environmentObject(CinelexNavigation())
}
