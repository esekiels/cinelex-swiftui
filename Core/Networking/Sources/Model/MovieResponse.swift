//
//  MovieResponse.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Model

public struct MovieResponse: Decodable, Sendable {
    
    public let page: Int
    public var results: [Movie]
    public let totalPages: Int
    
    public init(page: Int, results: [Movie], totalPages: Int, totalResults: Int) {
        self.page = page
        self.results = results
        self.totalPages = totalPages
    }
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
    }
}
