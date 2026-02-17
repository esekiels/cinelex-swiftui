//
//  UserPreferences.swift
//  Datastore
//
//  Created by Esekiel Surbakti on 17/02/26.
//

import SwiftUI

@Observable
public final class UserPreferences: @unchecked Sendable {

    private let defaults = UserDefaults.standard

    public var theme: AppTheme {
        didSet { defaults.set(theme.rawValue, forKey: "app_theme") }
    }

    public var locale: AppLocale {
        didSet { defaults.set(locale.rawValue, forKey: "app_locale") }
    }

    public init() {
        let themeRaw = UserDefaults.standard.string(forKey: "app_theme") ?? ""
        self.theme = AppTheme(rawValue: themeRaw) ?? .system

        let localeRaw = UserDefaults.standard.string(forKey: "app_locale") ?? ""
        self.locale = AppLocale(rawValue: localeRaw) ?? .system
    }
}
