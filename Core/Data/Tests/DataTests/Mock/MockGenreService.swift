//
//  MockGenreService.swift
//  Data
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import Network
import Model
import Common

final actor MockGenreService: GenreServiceProtocol {
  
    private var mockGenres: [Genre] = []
    private(set) var fetchGenresCalled = false
    
    func setMockGenres(_ genres: [Genre]) {
        mockGenres = genres
    }
    
    func fetchGenres() async throws -> [Model.Genre] {
        fetchGenresCalled = true
        return mockGenres
    }
}
