//
//  CinelexCoordinator.swift
//  Navigation
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

@Observable
public final class CinelexCoordinator: ObservableObject {
    
    public init () {}
    
    public var route: Route = .splash
    
    public enum Route: Equatable {
        case splash
        case home
    }
}
