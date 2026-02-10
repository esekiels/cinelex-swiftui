//
//  UiState.swift
//  Common
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public enum UiState {
    case idle
    case loading
    case error(CinelexError)
    
    public var isLoading: Bool {
        if case .loading = self {
            return true
        }
        return false
    }
    
    public var error: CinelexError? {
        if case .error(let error) = self {
            return error
        }
        return nil
    }
}
