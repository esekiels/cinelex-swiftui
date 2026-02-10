//
//  MovieEntity.swift
//  Database
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation
import Model

@Model
public final class MovieEntity {
    
    @Attribute(.unique) public var id: Int
    var title: String
    var posterPath: String
    var backdropPath: String
    var category: String
    var createdAt: Date
    
    init(id: Int, title: String, posterPath: String, backdropPath: String, category: String) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.category = category
        self.createdAt = Date()
    }
}

extension MovieEntity {
    
    func toDomain() -> Movie {
        Movie(id: id, title: title, backdropPath: backdropPath, posterPath: posterPath)
    }
    
    convenience init(_ movie: Movie, category: String) {
        self.init(
            id: movie.id,
            title: movie.title,
            posterPath: movie.posterPath,
            backdropPath: movie.backdropPath,
            category: category
        )
    }
}

extension Array where Element == MovieEntity {
    func toDomain() -> [Movie] { map { $0.toDomain() } }
}

extension Array where Element == Movie {
    func toEntities(category: String) -> [MovieEntity] {
        map { MovieEntity($0, category: category) }
    }
}
