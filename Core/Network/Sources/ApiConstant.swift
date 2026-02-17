//
//  Untitled.swift
//  Network
//
//  Created by Esekiel Surbakti on 09/02/26.
//

enum ApiConstant: String {
    
    case nowPlaying = "movie/now_playing"
    case upcoming = "movie/upcoming"
    case topRated = "movie/top_rated"
    case popular = "movie/popular"
    case details = "movie/{movie_id}"
    case genres = "genre/movie/list"
    case search = "search/movie"
}
