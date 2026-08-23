//
//  MoviePage.swift
//  Model
//
//  Created by Esekiel Surbakti on 12/03/26.
//

public struct MoviePage: Sendable {

    public let page: Int
    public let totalPages: Int
    public let results: [Movie]

    public init(page: Int, totalPages: Int, results: [Movie]) {
        self.page = page
        self.totalPages = totalPages
        self.results = results
    }
}
