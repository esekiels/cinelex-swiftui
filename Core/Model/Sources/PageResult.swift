//
//  PageResult.swift
//  Model
//
//  Created by Esekiel Surbakti on 12/03/26.
//

public struct PageResult<T: Sendable>: Sendable {

    public let page: Int
    public let totalPages: Int
    public let results: [T]

    public init(page: Int, totalPages: Int, results: [T]) {
        self.page = page
        self.totalPages = totalPages
        self.results = results
    }
}
