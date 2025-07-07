//
//  Movie+Stub.swift
//  Model
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation
import Base

public extension Movie {
    
    static var stubbedMovies: [Movie] {
        let response: MovieResponse? = try? Bundle.module.loadAndDecodeJSON(filename: "movie_list")
        return response?.results ?? []
    }
    
    static var stubbedMovie: Movie {
        stubbedMovies[0]
    }
}
