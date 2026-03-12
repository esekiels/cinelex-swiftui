//
//  CinelexDIFactory.swift
//  Cinelex
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Data
import Database
import Networking
import SwiftUI
import Home
import Details
import Search

@MainActor
public final class CinelexDIFactory: HomeFactory, SearchFactory {
    
    private lazy var movieRepository: MovieRepositoryProtocol = {
        MovieRepository(service: MovieService(), dao: MovieDao())
    }()

    private lazy var genreRepository: GenreRepositoryProtocol = {
        GenreRepository(service: GenreService(), dao: GenreDao())
    }()
    
    public func injectHomeViewModel() -> HomeViewModel {
        HomeViewModel(repository: movieRepository)
    }
    
    public func injectDetailsViewModel(_ movieId: Int) -> DetailsViewModel {
        DetailsViewModel(repository: movieRepository, movieId: movieId)
    }
    
    public func injectSearchViewModel() -> SearchViewModel {
        SearchViewModel(movieRepository: movieRepository, genreRepository: genreRepository)
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
