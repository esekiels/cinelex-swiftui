//
//  AppLocale.swift
//  Datastore
//
//  Created by Esekiel Surbakti on 17/02/26.
//

import Foundation

public enum AppLocale: String, CaseIterable, Sendable {
    case system
    case en
    case id

    public var title: String {
        switch self {
        case .system: "System"
        case .en: "English"
        case .id: "Indonesia"
        }
    }

    public var icon: String {
        switch self {
        case .system: "globe"
        case .en: "e.circle"
        case .id: "i.circle"
        }
    }

    public var locale: Locale {
        switch self {
        case .system: .current
        case .en: Locale(identifier: "en")
        case .id: Locale(identifier: "id")
        }
    }

    public var apiLanguage: String {
        switch self {
        case .system:
            Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
        case .en: "en-US"
        case .id: "id-ID"
        }
    }
}
