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
        get {
            let raw = defaults.string(forKey: "app_theme") ?? ""
            return AppTheme(rawValue: raw) ?? .system
        }
        set {
            defaults.set(newValue.rawValue, forKey: "app_theme")
        }
    }

    public init() {}
}
