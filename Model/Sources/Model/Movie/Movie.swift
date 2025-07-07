//
//  Movie.swift
//  Model
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation

public struct MovieResponse: Decodable, Sendable {
    public let results: [Movie]
}

public struct Movie: Decodable, Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let releaseDate: String
    public let posterPath: String
    public let backdropPath: String
    public let genres: [MovieGenre]?
    public let runtime: Int?
    public let overview: String
    public let voteAverage: Double
    public let credits: MovieCredit?
    public let videos: MovieVideos?
    
    private let IMAGE_URL = "https://image.tmdb.org/t/p/original"
    
    public var posterUrl: URL? {
        URL(string: IMAGE_URL + posterPath)
    }
    
    public var backDropUrl: URL? {
        URL(string: IMAGE_URL + backdropPath)
    }
    
    public var genreFormatted: String {
        genres?.first?.name ?? "n/a"
    }
    
    public var releaseYearFormatted: String {
        Date.from(releaseDate)?.toYearString() ?? "n/a"
    }
    
    public var cast: [MovieCast]? {
        credits?.cast
    }
    
    public var crew: [MovieCrew]? {
        credits?.crew
    }
    
    public var directors: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "director" }
    }
    
    public var producers: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "producer" }
    }
    
    public var screenwriters: [MovieCrew]? {
        crew?.filter { $0.job.lowercased() == "story" }
    }
    
    public var youtubeTrailers: [MovieVideo]? {
        videos?.results.filter { $0.youtubeURL != nil }
    }
    
    public var durationFormatted: String {
        guard let runtime = runtime, runtime > 0 else {
            return "n/a"
        }
        return durationFormatter.string(from: TimeInterval(runtime) * 60) ?? "n/a"
    }
    
    public var scoreRating: String {
        let rating = Double(voteAverage)
        guard rating > 0 else {
            return "n/a"
        }
        return String(format: "%.1f/10", rating)
    }
    
    public func isStarFilled(at index: Int) -> Bool {
        return (voteAverage - Double(index)) >= 0.5
    }
    
    private let durationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour, .minute]
        return formatter
    }()
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genres
        case runtime
        case overview
        case voteAverage = "vote_average"
        case credits
        case videos
    }
}

public struct MovieGenre: Decodable, Sendable {
    let name: String
}

public struct MovieCredit: Decodable, Sendable {
    
    public let cast: [MovieCast]
    let crew: [MovieCrew]
}

public struct MovieCast: Decodable, Identifiable, Sendable {
    public let id: Int
    let character: String
    public let name: String
}

public struct MovieCrew: Decodable, Identifiable, Sendable {
    public let id: Int
    let job: String
    public let name: String
}

public struct MovieVideos: Decodable, Sendable {
    public let results: [MovieVideo]
}

public struct MovieVideo: Decodable, Identifiable, Sendable {
    public let id: String
    public let key: String
    public let name: String
    public let site: String
    public let type: String
    
    public var youtubeURL: URL? {
        guard site == "YouTube" && type == "Trailer" else {
            return nil
        }
        return URL(string: "https://youtube.com/watch?v=\(key)")
    }
}
