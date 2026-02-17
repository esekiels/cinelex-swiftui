//
//  String+Extension.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public extension String {

    var localized: String {
        let appLocale = UserDefaults.standard.string(forKey: "app_locale") ?? ""
        let languageCode: String
        switch appLocale {
        case "en": languageCode = "en"
        case "id": languageCode = "id"
        default: languageCode = Locale.current.language.languageCode?.identifier ?? "en"
        }

        guard let path = Bundle.module.path(forResource: languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            // swiftlint:disable:next nslocalizedstring_key
            return NSLocalizedString(self, bundle: .module, comment: "")
        }
        // swiftlint:disable:next nslocalizedstring_key
        return NSLocalizedString(self, bundle: bundle, comment: "")
    }
}
