//
//  AppCordinator.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation

@MainActor
public class AppCordinator: ObservableObject {
    
    @Published public var currentRoute: Route = .splash
    
    public init() { }
    
    public enum Route {
        case splash
        case main
    }
}
