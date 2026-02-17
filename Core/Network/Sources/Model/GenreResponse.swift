//
//  GenreResponse.swift
//  Network
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Model

public struct GenreResponse: Decodable, Sendable {
    
    public let results: [Genre]
    
    enum CodingKeys: String, CodingKey {
        case results = "genres"
    }
}
