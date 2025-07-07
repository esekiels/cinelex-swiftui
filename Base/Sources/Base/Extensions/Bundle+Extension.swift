//
//  Bundle+Extension.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation

public extension Bundle {
    
    func loadAndDecodeJSON<D: Decodable>(filename: String) throws -> D? {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(D.self, from: data)
    }
}
