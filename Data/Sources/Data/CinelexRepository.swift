//
//  CinelexRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 06/07/25.
//

import Foundation
import Model
import Network
import Base

public protocol CinelexRepositoryProtocol: Sendable {
    
    func fetchNowPlaying() async throws -> [Movie]
    func fetchUpcoming() async throws -> [Movie]
    func fetchTopRated() async throws -> [Movie]
    func fetchPopular() async throws -> [Movie]
}

public final class CinelexRepository: CinelexRepositoryProtocol {
    
    private let networkManager: NetworkManager
    
    public init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    public func fetchNowPlaying() async throws -> [Model.Movie] {
        let url = generateUrl(path: ApiConstants.nowPlaying.rawValue)
        
        do {
            let response: MovieResponse = try await networkManager.get(url, token: Environment.TOKEN)
            
            return response.results
        } catch {
            throw error
        }
    }
    
    public func fetchUpcoming() async throws -> [Model.Movie] {
        let url = generateUrl(path: ApiConstants.upcoming.rawValue)
        
        do {
            let response: MovieResponse = try await networkManager.get(url, token: Environment.TOKEN)
            
            return response.results
        } catch {
            throw error
        }
    }
    
    public func fetchTopRated() async throws -> [Model.Movie] {
        let url = generateUrl(path: ApiConstants.topRated.rawValue)
        
        do {
            let response: MovieResponse = try await networkManager.get(url, token: Environment.TOKEN)
            
            return response.results
        } catch {
            throw error
        }
    }
    
    public func fetchPopular() async throws -> [Movie] {
        let url = generateUrl(path: ApiConstants.popular.rawValue)
        
        do {
            let response: MovieResponse = try await networkManager.get(url, token: Environment.TOKEN)
            
            return response.results
        } catch {
            throw error
        }
    }
    
    private func generateUrl(path: String) -> String {
        return "\(Environment.BASE_URL)\(path)?language=en-US&page=1"
    }
}
