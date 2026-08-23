//
//  BaseDaoProtocol.swift
//  Database
//
//  Created by Esekiel Surbakti on 23/08/26.
//

public protocol BaseDaoProtocol<T>: Sendable {
    associatedtype T: Sendable
    func get() async throws -> T
    func save(_ data: T) async throws
}

public enum DatabaseError: Error {
    case notFound
}
