//
//  CinelexDatabase.swift
//  Database
//
//  Created by Esekiel Surbakti on 09/02/26.
//

public final class DatabaseManager: @unchecked Sendable {
    
    public static let shared = DatabaseManager()
    
    public let container: ModelContainer
    
    private init() {
        let schema = Schema([
            MovieEntity.self
        ])
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )
        
        do {
            container = try ModelContainer(
                for: schema,
                configurations: [configuration]
            )
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}
