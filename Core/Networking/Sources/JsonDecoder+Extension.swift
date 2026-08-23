//
//  JsonDecoder+Extension.swift
//  Network
//
//  Created by Esekiel Surbakti on 23/08/26.
//

import Foundation

public extension JSONDecoder {

    static func tmdb() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
