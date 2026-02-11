//
//  MovieResponse.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Model

struct MovieResponse: Decodable {
    
    let results: [Movie]
}
