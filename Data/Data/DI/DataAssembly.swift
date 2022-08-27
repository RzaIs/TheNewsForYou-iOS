//
//  DataAssembly.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Firebase
import Swinject
import RealmSwift
import Domain
import Foundation

public class DataAssembly: Assembly {
    
    private let baseURL: String
    private let APIKey: String
    
    public init(
        baseURL: String,
        APIKey: String
    ) {
        FirebaseApp.configure()
        self.baseURL = baseURL
        self.APIKey = APIKey
    }
    
    public func assemble(container: Container) {
        
        // Realm
        
        container.register(Realm.self) { r in
            try! Realm(
                configuration: Realm.Configuration(
                    schemaVersion: 0,
                    deleteRealmIfMigrationNeeded: true
                )
            )
        }.inObjectScope(.container)
        
        // Providers
        
        container.register(DatabaseProviderProtocol.self) { r in
            DatabaseProvider(realm: r.resolve(Realm.self)!)
        }.inObjectScope(.container)
        
        container.register(FirebaseProviderProtocol.self) { r in
            FirebaseProvider()
        }.inObjectScope(.container)
        
        container.register(NetworkProviderProtocol.self) { r in
            NetworkProvider(
                baseURL: self.baseURL,
                APIKey: self.APIKey,
                logger: Logger(),
                adapters: [],
                retrier: []
            )
        }
        
        // Repositories
        
        container.register(AuthRepoProtocol.self) { r in
            AuthRepo(remoteDataSource: r.resolve(AuthRemoteDataSourceProtocol.self)!)
        }
        
        // Remote Data Sources
        
        container.register(AuthRemoteDataSourceProtocol.self) { r in
            AuthRemoteDataSource(firebaseProvider: r.resolve(FirebaseProviderProtocol.self)!)
        }
        
        // Local Data Sources
    }
}
