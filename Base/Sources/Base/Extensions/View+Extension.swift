//
//  View+Extension.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import SwiftUI

public extension View {

    func shimmerEffect() -> some View {
        modifier(Shimmer())
    }
}
