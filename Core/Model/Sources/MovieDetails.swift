//
//  MovieDetails.swift
//  Model
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import Foundation

public struct MovieDetails: Decodable, Sendable {
    public let id: Int
    public let title: String
    public let backdropPath: String?
    public let posterPath: String?
    public let overview: String
    public let voteAverage: Double
    public let releaseDate: String
    public let runtime: Int?
    public let genres: [Genre]
    public let credits: Credits?
    public let videos: VideoResponse?
    
    public init(
        id: Int,
        title: String,
        backdropPath: String?,
        posterPath: String?,
        overview: String,
        voteAverage: Double,
        releaseDate: String,
        runtime: Int?,
        genres: [Genre],
        credits: Credits?,
        videos: VideoResponse?
    ) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
        self.overview = overview
        self.voteAverage = voteAverage
        self.releaseDate = releaseDate
        self.runtime = runtime
        self.genres = genres
        self.credits = credits
        self.videos = videos
    }
    
    public var backdropURL: URL? {
        guard let backdropPath = backdropPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/original" + backdropPath)
    }
    
    public var posterURL: URL? {
        guard let posterPath = posterPath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/original" + posterPath)
    }
    
    public var genreFormatted: String {
        genres.isEmpty ? "N/A" : genres.map(\.name).joined(separator: ", ")
    }
    
    public var releaseYearFormatted: String {
        releaseDate.isEmpty ? "N/A" : String(releaseDate.prefix(4))
    }
    
    public var durationFormatted: String {
        guard let runtime = runtime else {
            return "N/A"
        }
        let hours = runtime / 60
        let minutes = runtime % 60
        return "\(hours)h \(minutes)m"
    }
    
    public var scoreRating: String {
        String(format: "%.1f", voteAverage)
    }
    
    public func isStarFilled(at index: Int) -> Bool {
        let roundedRating = voteAverage.rounded(.toNearestOrAwayFromZero)
        return Double(index) < roundedRating
    }
    
    public var cast: [Cast]? {
        credits?.cast
    }
    
    public var directors: [Crew]? {
        credits?.crew.filter { $0.job == "Director" }
    }
    
    public var producers: [Crew]? {
        credits?.crew.filter { $0.job == "Producer" }
    }
    
    public var screenwriters: [Crew]? {
        credits?.crew.filter { $0.job == "Screenplay" || $0.job == "Writer" }
    }
    
    public var youtubeTrailers: [Video]? {
        videos?.results.filter { $0.site == "YouTube" && $0.type == "Trailer" }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, credits, videos
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}

public struct Credits: Codable, Sendable {
    public let cast: [Cast]
    public let crew: [Crew]
    
    public init(cast: [Cast], crew: [Crew]) {
        self.cast = cast
        self.crew = crew
    }
}

public struct Cast: Identifiable, Codable, Sendable {
    public let id: Int
    public let name: String
    public let character: String
    public let profilePath: String?
    
    public var profileURL: URL? {
        guard let profilePath else {
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w185" + profilePath)
    }
    
    public init(id: Int, name: String, character: String, profilePath: String? = nil) {
        self.id = id
        self.name = name
        self.character = character
        self.profilePath = profilePath
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

public struct Crew: Identifiable, Codable, Sendable {
    public let id: Int
    public let name: String
    public let job: String
    
    public init(id: Int, name: String, job: String) {
        self.id = id
        self.name = name
        self.job = job
    }
}

public struct VideoResponse: Codable, Sendable {
    public let results: [Video]
    
    public init(results: [Video]) {
        self.results = results
    }
}

public struct Genre: Codable, Sendable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

public struct Video: Identifiable, Codable, Sendable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let type: String
    
    public init(id: String, key: String, name: String, site: String, type: String) {
        self.id = id
        self.key = key
        self.name = name
        self.site = site
        self.type = type
    }
    
    public var youtubeURL: URL? {
        guard site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

#if DEBUG
public extension MovieDetails {
    static let stub = MovieDetails(
        id: 278,
        title: "The Shawshank Redemption",
        backdropPath: "/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg",
        posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg",
        overview: "Imprisoned in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
        voteAverage: 8.7,
        releaseDate: "1994-09-23",
        runtime: 142,
        genres: [
            Genre(id: 18, name: "Drama"),
            Genre(id: 80, name: "Crime")
        ],
        credits: Credits(
            cast: [
                Cast(id: 504, name: "Tim Robbins", character: "Andy Dufresne"),
                Cast(id: 192, name: "Morgan Freeman", character: "Ellis Boyd 'Red' Redding"),
                Cast(id: 4029, name: "Bob Gunton", character: "Warden Samuel Norton"),
                Cast(id: 6574, name: "William Sadler", character: "Heywood"),
                Cast(id: 9857, name: "Clancy Brown", character: "Captain Byron Hadley")
            ],
            crew: [
                Crew(id: 4027, name: "Frank Darabont", job: "Director"),
                Crew(id: 4027, name: "Frank Darabont", job: "Screenplay"),
                Crew(id: 4028, name: "Niki Marvin", job: "Producer")
            ]
        ),
        videos: VideoResponse(
            results: [
                Video(
                    id: "1",
                    key: "PLl99DlL6b4",
                    name: "Official Trailer",
                    site: "YouTube",
                    type: "Trailer"
                )
            ]
        )
    )
}
#endif
