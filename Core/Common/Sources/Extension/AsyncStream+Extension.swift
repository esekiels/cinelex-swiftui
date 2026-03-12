//
//  AsyncStream+Extension.swift
//  Common
//
//  Created by Esekiel Surbakti on 12/03/26.
//

public extension AsyncStream where Element: Sendable {
    
    static func just(_ value: Element) -> AsyncStream {
        AsyncStream { $0.yield(value); $0.finish() }
    }
    
    static func onDataStream(
        dao: @Sendable @escaping () async throws -> Element?,
        service: @Sendable @escaping () async throws -> Element,
        then: @Sendable @escaping (Element) async throws -> Void
    ) -> AsyncStream {
        AsyncStream { continuation in
            Task {
                if let cached = try? await dao() {
                    continuation.yield(cached)
                }

                if let fresh = try? await service() {
                    try? await then(fresh)
                    continuation.yield(fresh)
                }
                
                continuation.finish()
            }
        }
    }
}
