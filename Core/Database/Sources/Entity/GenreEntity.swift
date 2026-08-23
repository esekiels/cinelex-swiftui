//
//  GenreEntity.swift
//  Database
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Model

@Model
public final class GenreEntity {
    
    @Attribute(.unique) public var id: Int
    var name: String
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension GenreEntity {
    
    func toDomain() -> Genre {
        Genre(id: id, name: name)
    }
}

extension Array where Element == GenreEntity {
    func toDomain() -> [Genre] { map { $0.toDomain() } }
}
