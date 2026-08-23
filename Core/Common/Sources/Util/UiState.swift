//
//  UiState.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public enum UiState: Equatable {
    case idle
    case loading
    case error(CinelexError)
}
