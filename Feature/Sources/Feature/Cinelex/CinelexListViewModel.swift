//
//  CinelexListViewModel.swift
//  Feature
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation
import Base
import Model
import Data
import Network

@MainActor
final class CinelexListViewModel: ObservableObject {
    
    // MARK: - Properties
    
    private let repository: CinelexRepositoryProtocol
    
    @Published var nowPlayingState: ViewModelState<[Movie]> = .idle {
        didSet { handleStateChange(nowPlayingState) }
    }
    
    @Published var upcomingState: ViewModelState<[Movie]> = .idle {
        didSet { handleStateChange(upcomingState) }
    }
    
    @Published var topRatedState: ViewModelState<[Movie]> = .idle {
        didSet { handleStateChange(topRatedState) }
    }
    
    @Published var popularState: ViewModelState<[Movie]> = .idle {
        didSet { handleStateChange(popularState) }
    }
    
    @Published var isAlertPresented: Bool = false
    
    @Published var errorMessage: String = ""
    
    init(repository: CinelexRepositoryProtocol = CinelexRepository()) {
        self.repository = repository
        Task {
            await fetchAllLists()
        }
    }
    
    // MARK: - Helpers
    
    private func fetchNowPlaying() async {
        nowPlayingState = .loading
        do {
            let movies = try await repository.fetchNowPlaying()
            nowPlayingState = .success(data: movies)
        } catch {
            nowPlayingState = .error(error: onError(error, from: "Now Playing"))
        }
    }
    
    private func fetchUpcoming() async {
        upcomingState = .loading
        do {
            let movies = try await repository.fetchUpcoming()
            upcomingState = .success(data: movies)
        } catch {
            upcomingState = .error(error: onError(error, from: "Upcoming"))
        }
    }
    
    private func fetchTopRated() async {
        topRatedState = .loading
        do {
            let movies = try await repository.fetchTopRated()
            topRatedState = .success(data: movies)
        } catch {
            topRatedState = .error(error: onError(error, from: "Top Rated"))
        }
    }
    
    private func fetchPopular() async {
        popularState = .loading
        do {
            let movies = try await repository.fetchPopular()
            popularState = .success(data: movies)
        } catch {
            popularState = .error(error: onError(error, from: "Popular"))
        }
    }
    
    func fetchAllLists() async {
        nowPlayingState = .loading
        upcomingState = .loading
        topRatedState = .loading
        popularState = .loading
        
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchNowPlaying() }
            group.addTask { await self.fetchUpcoming() }
            group.addTask { await self.fetchTopRated() }
            group.addTask { await self.fetchPopular() }
        }
    }
    
    private func handleStateChange<T>(_ state: ViewModelState<T>) {
        if case .error = state {
            isAlertPresented = true
        } else {
            isAlertPresented = false
        }
    }
    
    private func onError(_ error: Error, from: String) -> AppError {
        if let apiError = error as? ApiError {
            let resovableError = apiError.value()
            let code = resovableError.code
            let newDescription = "\(from): \(resovableError.description)"
            errorMessage = newDescription
            AppLogger.debug("code: \(code) message: \(resovableError.description)")
            return resovableError
        } else {
            AppLogger.debug("message: \(error.localizedDescription)")
            return AppError(code: ErrorConstants.unknownError.rawValue, description: "Something went wrong")
        }
    }
}
