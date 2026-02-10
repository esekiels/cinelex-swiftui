//
//  String+Extension.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public extension String {
    
    var localized: String {
        // swiftlint:disable:next nslocalizedstring_key
        NSLocalizedString(self, bundle: .module, comment: "")
    }
}
