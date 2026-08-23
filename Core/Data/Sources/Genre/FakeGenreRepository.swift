//
//  FakeGenreRepository.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Common
import Model

#if DEBUG
public final class FakeGenreRepository: GenreRepositoryProtocol, @unchecked Sendable {

    public var genres: [Genre]

    public init(genres: [Genre] = Genre.stubs) {
        self.genres = genres
    }

    public func fetchGenres() -> DataStream<[Genre]> {
        .just(genres)
    }
}
#endif
