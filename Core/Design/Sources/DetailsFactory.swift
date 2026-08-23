//
//  DetailsFactory.swift
//  Design
//
//  Created by Esekiel Surbakti on 12/02/26.
//

import SwiftUI

@MainActor
public protocol DetailsFactory: Sendable {
    func makeDetailsView(_ movieId: Int) -> AnyView
}

public struct DetailsFactoryKey: EnvironmentKey {
    public static let defaultValue: DetailsFactory? = nil
}

public extension EnvironmentValues {
    var detailsFactory: DetailsFactory? {
        get { self[DetailsFactoryKey.self] }
        set { self[DetailsFactoryKey.self] = newValue }
    }
}
