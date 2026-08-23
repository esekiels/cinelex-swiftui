//
//  TestContainer.swift
//  Database
//
//  Created by Esekiel Surbakti on 23/08/26.
//

import Foundation
import SwiftData
@testable import Database

enum TestContainer {

    static let shared: ModelContainer = {
        let schema = Schema([MovieEntity.self, MovieDetailsEntity.self, GenreEntity.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        // swiftlint:disable:next force_try
        return try! ModelContainer(for: schema, configurations: config)
    }()
}
