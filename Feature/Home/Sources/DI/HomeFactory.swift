//
//  HomeFactory.swift
//  Home
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import SwiftUI

@MainActor
public protocol HomeFactory: Sendable {
    func makeDetailsView(_ movieId: Int) -> AnyView
}

public struct HomeFactoryKey: EnvironmentKey {
    public static let defaultValue: HomeFactory? = nil
}

public extension EnvironmentValues {
    var homeFactory: HomeFactory? {
        get { self[HomeFactoryKey.self] }
        set { self[HomeFactoryKey.self] = newValue }
    }
}
