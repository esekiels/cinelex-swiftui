//
//  SearchFactory.swift
//  Search
//
//  Created by Esekiel Surbakti on 14/02/26.
//

import SwiftUI

@MainActor
public protocol SearchFactory: Sendable {
    func makeDetailsView(_ movieId: Int) -> AnyView
}

public struct SearchFactoryKey: EnvironmentKey {
    public static let defaultValue: SearchFactory? = nil
}

public extension EnvironmentValues {
    var searchFactory: SearchFactory? {
        get { self[SearchFactoryKey.self] }
        set { self[SearchFactoryKey.self] = newValue }
    }
}
