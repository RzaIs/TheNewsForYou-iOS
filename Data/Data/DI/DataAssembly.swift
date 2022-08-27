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
import KeychainAccess

public class DataAssembly: Assembly {
    
    private let baseURL: String
    private let APIKey: String
    private let keychainService: String
    
    public init(
        baseURL: String,
        APIKey: String,
        keychainService: String
    ) {
        FirebaseApp.configure()
        self.baseURL = baseURL
        self.APIKey = APIKey
        self.keychainService = keychainService
    }
    
    public func assemble(container: Container) {
        
        // Realm & Keychain
        
        container.register(Realm.self) { r in
            try! Realm(
                configuration: Realm.Configuration(
                    schemaVersion: 0,
                    deleteRealmIfMigrationNeeded: true
                )
            )
        }.inObjectScope(.container)
        
        container.register(Keychain.self) { r in
            Keychain(service: self.keychainService)
        }.inObjectScope(.container)
        
        // Providers
        
        container.register(DatabaseProviderProtocol.self) { r in
            DatabaseProvider(
                realm: r.resolve(Realm.self)!,
                keychain: r.resolve(Keychain.self)!
            )
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
                retriers: []
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
