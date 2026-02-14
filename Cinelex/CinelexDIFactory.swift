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
import Details

@MainActor
public final class CinelexDIFactory: HomeFactory {

    private lazy var homeRepository: HomeRepositoryProtocol = {
        HomeRepository(
            service: MovieService(),
            genreService: GenreService(),
            dao: MovieDao(),
            genreDao: GenreDao()
        )
    }()
    
    private lazy var detailsRepository: DetailsRepositoryProtocol = {
        DetailsRepository(service: MovieService(), dao: MovieDetailsDao())
    }()
    
    public func injectHomeViewModel() -> HomeViewModel {
        HomeViewModel(repository: homeRepository)
    }
    
    public func injectDetailsViewModel(_ movieId: Int) -> DetailsViewModel {
        DetailsViewModel(repository: detailsRepository, movieId: movieId)
    }
    
    // MARK: - Modules DI Factory
    
    public func makeDetailsView(_ movieId: Int) -> AnyView {
        return AnyView(DetailsView(viewModel: injectDetailsViewModel(movieId)))
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
