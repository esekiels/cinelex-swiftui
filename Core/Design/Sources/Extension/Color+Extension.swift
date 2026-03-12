//
//  Color+Extension.swift
//  Design
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import SwiftUI

public extension Color {
    static let colorPrimary = Color("primary", bundle: .module)
    static let colorbackground = Color("background", bundle: .module)
    static let textPrimary = Color("textPrimary", bundle: .module)
    static let textSecondary = Color("textSecondary", bundle: .module)
}

public extension ShapeStyle where Self == Color {
    static var textPrimary: Color { .textPrimary }
    static var textSecondary: Color { .textSecondary }
}
