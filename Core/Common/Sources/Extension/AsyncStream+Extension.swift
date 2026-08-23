//
//  AsyncStream+Extension.swift
//  Common
//
//  Created by Esekiel Surbakti on 12/03/26.
//

public typealias DataStream<T> = AsyncStream<Result<T, CinelexError>>

public extension AsyncStream {

    static func just<Value: Sendable>(_ value: Value) -> AsyncStream
    where Element == Result<Value, CinelexError> {
        AsyncStream { continuation in
            continuation.yield(.success(value))
            continuation.finish()
        }
    }

    static func onDataStream<Value: Sendable>(
        dao: @Sendable @escaping () async throws -> Value?,
        service: @Sendable @escaping () async throws -> Value,
        then: @Sendable @escaping (Value) async throws -> Void
    ) -> AsyncStream where Element == Result<Value, CinelexError> {
        AsyncStream { continuation in
            let task = Task {
                if let cached = try? await dao() {
                    continuation.yield(.success(cached))
                }

                do {
                    let fresh = try await service()
                    try? await then(fresh)
                    continuation.yield(.success(fresh))
                } catch {
                    continuation.yield(.failure(error.toCinelexError()))
                }

                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}
