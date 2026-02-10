//
//  CinelexDIFactory.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Data
import Database
import Network
import SwiftUI
import Home

public final class CinelexDIFactory: @unchecked Sendable {

    private lazy var homeRepository: HomeRepositoryProtocol = {
        HomeRepository(dao: MovieDao(), service: MovieService())
    }()
    
    public func injectHomeViewModel() -> HomeViewModel {
        HomeViewModel(repository: homeRepository)
    }
}

public struct DependencyFactoryKey: EnvironmentKey {
    public static let defaultValue = CinelexDIFactory()
}

public extension EnvironmentValues {
    var factory: CinelexDIFactory {
        get { self[DependencyFactoryKey.self] }
        set { self[DependencyFactoryKey.self] = newValue }
    }
}
