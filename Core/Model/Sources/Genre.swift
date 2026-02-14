//
//  Genre.swift
//  Model
//
//  Created by Esekiel Surbakti on 14/02/26.
//

public struct Genre: Codable, Sendable {
    public let id: Int
    public let name: String
    
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

#if DEBUG
public extension Genre {
    static let stubs: [Genre] = [
        Genre(id: 10, name: "Sci-fi"),
        Genre(id: 11, name: "Anime"),
        Genre(id: 12, name: "Comedy")
    ]
}
#endif
