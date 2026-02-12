//
//  MovieDetailsEntity.swift
//  Database
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Foundation
import Model

@Model
public final class MovieDetailsEntity {
    
    @Attribute(.unique) public var id: Int
    var title: String
    var backdropPath: String?
    var posterPath: String?
    var overview: String
    var voteAverage: Double
    var releaseDate: String
    var runtime: Int?
    var genresJson: String
    var castJson: String?
    var crewJson: String?
    var videosJson: String?
    var createdAt: Date
    
    init(
        id: Int,
        title: String,
        backdropPath: String?,
        posterPath: String?,
        overview: String,
        voteAverage: Double,
        releaseDate: String,
        runtime: Int?,
        genresJson: String,
        castJson: String?,
        crewJson: String?,
        videosJson: String?,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.overview = overview
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.genresJson = genresJson
        self.castJson = castJson
        self.crewJson = crewJson
        self.videosJson = videosJson
        self.createdAt = createdAt
    }
}

// MARK: - Domain Mapping

extension MovieDetailsEntity {
    
    convenience init(_ movie: MovieDetails) {
        let encoder = JSONEncoder()
        self.init(
            id: movie.id,
            title: movie.title,
            backdropPath: movie.backdropPath,
            posterPath: movie.posterPath,
            overview: movie.overview,
            voteAverage: movie.voteAverage,
            releaseDate: movie.releaseDate,
            runtime: movie.runtime,
            genresJson: String(data: (try? encoder.encode(movie.genres)) ?? Data(), encoding: .utf8) ?? "[]",
            castJson: String(data: (try? encoder.encode(movie.credits?.cast)) ?? Data(), encoding: .utf8),
            crewJson: String(data: (try? encoder.encode(movie.credits?.crew)) ?? Data(), encoding: .utf8),
            videosJson: String(data: (try? encoder.encode(movie.videos?.results)) ?? Data(), encoding: .utf8)
        )
    }
    
    func toDomain() -> MovieDetails {
        let decoder = JSONDecoder()
        let genres = (try? decoder.decode([Genre].self, from: Data(genresJson.utf8))) ?? []
        let cast = castJson.flatMap { try? decoder.decode([Cast].self, from: Data($0.utf8)) }
        let crew = crewJson.flatMap { try? decoder.decode([Crew].self, from: Data($0.utf8)) }
        let videos = videosJson.flatMap { try? decoder.decode([Video].self, from: Data($0.utf8)) }
        
        let credits: Credits? = if let cast, let crew {
            Credits(cast: cast, crew: crew)
        } else {
            nil
        }
        
        let videoResponse: VideoResponse? = videos.map { VideoResponse(results: $0) }
        
        return MovieDetails(
            id: id,
            title: title,
            backdropPath: backdropPath,
            posterPath: posterPath,
            overview: overview,
            voteAverage: voteAverage,
            releaseDate: releaseDate,
            runtime: runtime,
            genres: genres,
            credits: credits,
            videos: videoResponse
        )
    }
}
