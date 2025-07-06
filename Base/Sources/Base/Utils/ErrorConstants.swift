//
//  ErrorContract.swift
//  Base
//
//  Created by Esekiel Surbakti on 06/07/25.
//

public enum ErrorConstants: String {
    case httpDecodingError = "E001"
    case networkError = "E002"
    case httpUnauthorized = "E003"
    case httpForbidden = "E004"
    case httpNotFound = "E0005"
    case httpTimeout = "E006"
    case httpEmptyBody = "E007"
    case unknownError = "E999"
}
