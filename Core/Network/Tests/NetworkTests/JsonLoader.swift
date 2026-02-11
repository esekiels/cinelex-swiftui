//
//  JsonLoader.swift
//  Test
//
//  Created by Esekiel Surbakti on 11/02/26.
//

import Foundation

enum JsonLoader {
    static func load<T: Decodable>(_ filename: String, as type: T.Type) -> T {
        let bundle = Bundle.module
        guard let url = bundle.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode(T.self, from: data) else {
            fatalError("Failed to load \(filename).json")
        }
        return decoded
    }
}
