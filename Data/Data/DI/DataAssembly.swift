//
//  DataAssembly.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Swinject
import RealmSwift
import Domain
import Firebase
import KeychainAccess

public class DataAssembly: Assembly {
    
    private let baseURL: String
    private let keychainService: String
    
    public init(
        baseURL: String,
        keychainService: String
    ) {
        FirebaseApp.configure()
        self.baseURL = baseURL
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
        
        container.register(Logger.self) { r in
            Logger()
        }
        
        container.register(NetworkProviderProtocol.self) { r in
            NetworkProvider(
                firebaseProvider: r.resolve(FirebaseProviderProtocol.self)!,
                baseURL: self.baseURL,
                logger: r.resolve(Logger.self)!,
                adapters: [
                    LogAdapter(
                        logger: r.resolve(Logger.self)!
                    )
                ],
                retriers: []
            )
        }
        
        // Repositories
        
        container.register(AuthRepoProtocol.self) { r in
            AuthRepo(
                remoteDataSource: r.resolve(AuthRemoteDataSourceProtocol.self)!,
                localDataSource: r.resolve(AuthLocalDataSourceProtocol.self)!
            )
        }
        
        container.register(TopStoriesRepoProtocol.self) { r in
            TopStoriesRepo(
                localDataSource: r.resolve(TopStoriesLocalDataSourceProtocol.self)!,
                remoteDataSource: r.resolve(TopStoriesRemoteDataSourceProtocol.self)!
            )
        }
        
        container.register(MostPopularRepoProtocol.self) { r in
            MostPopularRepo(
                localDataSource: r.resolve(MostPopularLocalDataSourceProtocol.self)!,
                remoteDataSource: r.resolve(MostPopularRemoteDataSourceProtocol.self)!
            )
        }
        
        container.register(CommentRepoProtocol.self) { r in
            CommentRepo(remoteDataSource: r.resolve(CommentRemoteDataSourceProtocol.self)!)
        }
        
        container.register(LikeRepoProtocol.self) { r in
            LikeRepo(likeRemoteDataSource: r.resolve(LikeRemoteDataSourceProtocol.self)!)
        }
        
        container.register(SearchArticleRepoProtocol.self) { r in
            SearchArticleRepo(remoteDataSource: r.resolve(SearchArticleRemoteDataSourceProtocol.self)!)
        }
        
        // Remote Data Sources
        
        container.register(AuthRemoteDataSourceProtocol.self) { r in
            AuthRemoteDataSource(firebaseProvider: r.resolve(FirebaseProviderProtocol.self)!)
        }
        
        container.register(TopStoriesRemoteDataSourceProtocol.self) { r in
            TopStoriesRemoteDataSource(networkProvider: r.resolve(NetworkProviderProtocol.self)!)
        }
        
        container.register(MostPopularRemoteDataSourceProtocol.self) { r in
            MostPopularRemoteDataSource(networkProvider: r.resolve(NetworkProviderProtocol.self)!)
        }
        
        container.register(CommentRemoteDataSourceProtocol.self) { r in
            CommentRemoteDataSource(firebaseProvider: r.resolve(FirebaseProviderProtocol.self)!)
        }
        
        container.register(LikeRemoteDataSourceProtocol.self) { r in
            LikeRemoteDataSource(firebaseProvider: r.resolve(FirebaseProviderProtocol.self)!)
        }
        
        container.register(SearchArticleRemoteDataSourceProtocol.self) { r in
            SearchArticleRemoteDataSource(networkProvider: r.resolve(NetworkProviderProtocol.self)!)
        }
        
        // Local Data Sources
        
        container.register(AuthLocalDataSourceProtocol.self) { r in
            AuthLocalDataSource(databaseProvider: r.resolve(DatabaseProviderProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(TopStoriesLocalDataSourceProtocol.self) { r in
            TopStoriesLocalDataSource(databaseProvider: r.resolve(DatabaseProviderProtocol.self)!)
        }.inObjectScope(.container)
        
        container.register(MostPopularLocalDataSourceProtocol.self) { r in
            MostPopularLocalDataSource(databaseProvider: r.resolve(DatabaseProviderProtocol.self)!)
        }.inObjectScope(.container)
    }
}
