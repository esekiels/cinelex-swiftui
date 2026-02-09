//
//  Image+Extension.swift
//  Design
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import SwiftUI

public extension Image {
    
    static func module(_ named: String) -> Image {
        return Image(named, bundle: .module)
    }
}
