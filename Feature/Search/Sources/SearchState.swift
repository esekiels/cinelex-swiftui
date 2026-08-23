//
//  SearchState.swift
//  Search
//
//  Created by Esekiel Surbakti on 23/08/26.
//

import Common
import Model

struct SearchState: Equatable {

    var uiState: UiState = .idle

    var movies: [Movie] = []
    var recommendations: [Movie] = []
    var isLoadingMore: Bool = false
}
