//
//  GenreRepositoryTests.swift
//  Data
//
//  Created by Esekiel Surbakti on 12/03/26.
//

import Testing
import Model
@testable import Data

@Suite
struct GenreRepositoryTests {

    private func makeSUT() -> (sut: GenreRepository, service: MockGenreService, dao: MockGenreDao) {
        let service = MockGenreService()
        let dao = MockGenreDao()
        let sut = GenreRepository(service: service, dao: dao)
        return (sut, service, dao)
    }

    private func collect<T>(_ stream: AsyncStream<T>) async -> [T] {
        var values: [T] = []
        for await value in stream { values.append(value) }
        return values
    }

    @Test func fetchGenresFromNetwork() async {
        let (sut, service, _) = makeSUT()
        await service.setMockGenres(Genre.stubs)

        let results = await collect(sut.fetchGenres())

        #expect(results.count == 1)
        #expect(results[0].count == Genre.stubs.count)
    }

    @Test func fetchGenresFromCacheThenNetwork() async {
        let (sut, service, dao) = makeSUT()
        await dao.seedGenres(Genre.stubs)
        await service.setMockGenres(Genre.stubs)

        let results = await collect(sut.fetchGenres())

        #expect(results.count == 2)
        #expect(results[0].count == Genre.stubs.count)
        #expect(results[1].count == Genre.stubs.count)
    }

    @Test func fetchGenresSavesToDao() async {
        let (sut, service, dao) = makeSUT()
        await service.setMockGenres(Genre.stubs)

        _ = await collect(sut.fetchGenres())

        #expect(await dao.saveCalled == true)
    }
}
