//
//  CinelexNavigation.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation

class CinelexNavigation: ObservableObject {

    public enum Route: Hashable {
        case detail(id: Int)
    }
    
    @Published var path: [Route] = []
    
    func navigate(to route: Route) {
        path.append(route)
    }
}
