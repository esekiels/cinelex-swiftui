//
//  CinelixBackdropCarouselView.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI
import Model

struct CinelixBackdropCarouselView: View {
    
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
                HStack(alignment: .top, spacing: 16) {
                    ForEach(self.movies) { movie in
                        CinelixBackdropCard(movie: movie)
                            .frame(width: 272, height: 200)
                            .onTapGesture {
                                navigation.navigate(to: .detail(id: movie.id))
                            }
                            .accessibilityAddTraits(.isButton)
                            .accessibilityLabel("View details for \(movie.title)")
                            .buttonStyle(PlainButtonStyle())
                            .padding(.leading, movie.id == movies.first?.id ? 16 : 0)
                            .padding(.trailing, movie.id == movies.last?.id ? 16 : 0)
                    }
                }
            }
        }
    }
}

#Preview {
    CinelixBackdropCarouselView(title: "Now Playing", movies: Movie.stubbedMovies)
        .environmentObject(CinelexNavigation())
}
