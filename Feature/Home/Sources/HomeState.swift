//
//  HomeState.swift
//  Home
//
//  Created by Esekiel Surbakti on 23/08/26.
//

import Common
import Model

struct HomeState: Equatable {
    
    var uiState: UiState = .loading
    
    var nowPlaying: [Movie] = []
    var popular: [Movie] = []
    var upcoming: [Movie] = []
    var topRated: [Movie] = []
}
