//
//  DetailsView.swift
//  Details
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Common
import Design
import Model
import Kingfisher
import Data

public struct DetailsView: View {
    
    @State private var viewModel: DetailsViewModel
    @State private var selectedTrailer: Video?
    
    public init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        Group {
            switch viewModel.state {
            case .idle:
                if let movie = viewModel.movie {
                    content(movie)
                }
            default:
                DetailsSkeletonView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.fetchDetails()
        }
        .sheet(item: $selectedTrailer) { trailer in
            if let url = trailer.youtubeURL {
                SafariView(url: url)
            }
        }
        .navigationTitle(viewModel.title)
    }
    
    // MARK: - Content
    
    private func content(_ movie: MovieDetails) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                backdrop(movie)
                VStack(alignment: .leading, spacing: 20) {
                    info(movie)
                    overview(movie)
                    rating(movie)
                    castSection(movie)
                    crewSection(movie)
                    trailerSection(movie)
                }
                .padding(16)
            }
        }
    }
    
    // MARK: - Backdrop
    
    private func backdrop(_ movie: MovieDetails) -> some View {
        KFImage.url(movie.backdropURL)
            .placeholder { ImagePlaceholder(16 / 9) }
            .resizable()
            .loadDiskFileSynchronously()
            .cacheOriginalImage()
            .scaleFactor(UIScreen.main.scale)
            .fade(duration: 0.2)
            .aspectRatio(16 / 9, contentMode: .fill)
    }
    
    // MARK: - Info
    
    private func info(_ movie: MovieDetails) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 4) {
                Text(movie.genreFormatted)
                Text("·")
                Text(movie.releaseYearFormatted)
                Text("·")
                Text(movie.durationFormatted)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Overview
    
    private func overview(_ movie: MovieDetails) -> some View {
        Text(movie.overview)
            .font(.body)
    }
    
    // MARK: - Rating
    
    private func rating(_ movie: MovieDetails) -> some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                ForEach(0..<10, id: \.self) { index in
                    Image(systemName: movie.isStarFilled(at: index) ? "star.fill" : "star")
                        .accessibilityLabel("ratingIcon")
                        .font(.caption2)
                        .foregroundStyle(movie.isStarFilled(at: index) ? .yellow : .gray)
                }
            }
            Text(movie.scoreRating)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    // MARK: - Cast
    
    @ViewBuilder
    private func castSection(_ movie: MovieDetails) -> some View {
        if let cast = movie.cast, !cast.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizeConstant.cast)
                    .font(.headline)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 12) {
                        ForEach(cast.prefix(10)) { member in
                            castCard(member)
                        }
                    }
                }
            }
        }
    }

    private func castCard(_ member: Cast) -> some View {
        VStack(spacing: 6) {
            KFImage.url(member.profileURL)
                .placeholder {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundStyle(.tertiary)
                        .accessibilityLabel("profileIcon")
                }
                .resizable()
                .scaleFactor(UIScreen.main.scale)
                .fade(duration: 0.2)
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipShape(Circle())
            
            Text(member.name)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(1)
            
            Text(member.character)
                .font(.caption2)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .frame(width: 80)
    }
    
    // MARK: - Crew
    
    @ViewBuilder
    private func crewSection(_ movie: MovieDetails) -> some View {
        let directors = movie.directors ?? []
        let producers = movie.producers ?? []
        let writers = movie.screenwriters ?? []
        
        if !directors.isEmpty || !producers.isEmpty || !writers.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizeConstant.crew)
                    .font(.headline)
                
                crewRow(LocalizeConstant.director, crew: directors)
                crewRow(LocalizeConstant.producer, crew: producers)
                crewRow(LocalizeConstant.writer, crew: writers)
            }
        }
    }

    @ViewBuilder
    private func crewRow(_ title: String, crew: [Crew]) -> some View {
        if !crew.isEmpty {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                Text(crew.map(\.name).joined(separator: ", "))
                    .font(.subheadline)
            }
        }
    }
    
    // MARK: - Trailers
    
    @ViewBuilder
    private func trailerSection(_ movie: MovieDetails) -> some View {
        if let trailers = movie.youtubeTrailers, !trailers.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text(LocalizeConstant.trailers)
                    .font(.headline)
                
                ForEach(trailers) { trailer in
                    trailerRow(trailer)
                }
            }
        }
    }
    
    private func trailerRow(_ trailer: Video) -> some View {
        Button {
            selectedTrailer = trailer
        } label: {
            HStack {
                Image(systemName: "play.circle.fill")
                    .font(.title3)
                    .accessibilityLabel("trailerPlayIcon")
                Text(trailer.name)
                    .font(.subheadline)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        DetailsView(
            viewModel: DetailsViewModel(
                repository: FakeDetailsRepository(),
                movieId: 278
            )
        )
    }
}
