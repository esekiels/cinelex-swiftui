//
//  String+Extension.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

public extension String {
    
    var localized: String {
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}
