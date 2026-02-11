//
//  Movie.swift
//  Model
//
//  Created by Esekiel Surbakti on 09/02/26.
//

import Foundation

public struct Movie: Identifiable, Hashable, Decodable, Sendable {
    
    public init(id: Int, title: String, backdropPath: String, posterPath: String) {
        self.id = id
        self.title = title
        self.backdropPath = backdropPath
        self.posterPath = posterPath
    }
    
    public let id: Int
    public let title: String
    public let backdropPath: String
    public let posterPath: String
    
    private let imageUrl = "https://image.tmdb.org/t/p/original"
    
    public var posterUrl: URL? {
        URL(string: imageUrl + posterPath)
    }
    
    public var backdropUrl: URL? {
        URL(string: imageUrl + backdropPath)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}

#if DEBUG
public extension Movie {
    static let stub = Movie(
        id: 278,
        title: "The Shawshank Redemption",
        backdropPath: "/zfbjgQE1uSd9wiPTX4VzsLi0rGG.jpg",
        posterPath: "/9cqNxx0GxF0bflZmeSMuL5tnGzr.jpg"
    )
    
    static let stubs: [Movie] = [
        .stub,
        Movie(
            id: 238,
            title: "The Godfather",
            backdropPath: "/tSPT36ZKlP2WVHJLM4cQPLSzv3b.jpg",
            posterPath: "/3bhkrj58Vtu7enYsRolD1fZdja1.jpg"
        ),
        Movie(
            id: 240,
            title: "The Godfather Part II",
            backdropPath: "/kGzFbGhp99zva6oZODW5atUtnqi.jpg",
            posterPath: "/hek3koDUyRQk7FIhPXsa6mT2Zc3.jpg"
        ),
        Movie(
            id: 424,
            title: "Schindler's List",
            backdropPath: "/zb6fM1CX41D9rF9hdgclu0peUmy.jpg",
            posterPath: "/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg"
        ),
        Movie(
            id: 155,
            title: "The Dark Knight",
            backdropPath: "/dqK9Hag1054tghRQSqLSfrkvQnA.jpg",
            posterPath: "/qJ2tW6WMUDux911r6m7haRef0WH.jpg"
        ),
        Movie(
            id: 497,
            title: "The Green Mile",
            backdropPath: "/b6HWTOxn1xevvyHU2K9ICvaRU6g.jpg",
            posterPath: "/8VG8fDNiy50H4FedGwdSVUPoaJe.jpg"
        ),
        Movie(
            id: 157336,
            title: "Interstellar",
            backdropPath: "/8sNiAPPYU14PUepFNeSNGUTiHW.jpg",
            posterPath: "/gEU2QniE6E77NI6lCU6MxlNBvIx.jpg"
        ),
        Movie(
            id: 13,
            title: "Forrest Gump",
            backdropPath: "/67HggiWaP9ZLv5sPYmyRV37yAJM.jpg",
            posterPath: "/saHP97rTPS5eLmrLQEcANmKrsFl.jpg"
        ),
        Movie(
            id: 680,
            title: "Pulp Fiction",
            backdropPath: "/96hiUXEuYsu4tcnvlaY8tEMFM0m.jpg",
            posterPath: "/vQWk5YBFWF4bZaofAbv0tShwBvQ.jpg"
        ),
        Movie(
            id: 496243,
            title: "Parasite",
            backdropPath: "/hiKmpZMGZsrkA3cdce8a7Dpos1j.jpg",
            posterPath: "/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg"
        )
    ]
}
#endif
