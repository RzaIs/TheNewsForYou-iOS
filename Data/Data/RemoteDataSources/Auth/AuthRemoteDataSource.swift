//
//  AuthRemoteDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Domain

class AuthRemoteDataSource: AuthRemoteDataSourceProtocol {
    
    private let firebaseProvider: FirebaseProviderProtocol
        
    init(firebaseProvider: FirebaseProviderProtocol) {
        self.firebaseProvider = firebaseProvider
    }
    
    func loggedIn() -> Bool {
        self.firebaseProvider.isSignedIn()
    }
    
    func register(credentials: AuthInput) async throws {
        try await self.firebaseProvider.createUser(email: credentials.email, password: credentials.password)
    }
    
    func login(credentials: AuthInput) async throws {
        try await self.firebaseProvider.signin(email: credentials.email, password: credentials.password)
    }
    
    func logout() throws {
        try self.firebaseProvider.signout()
    }
}
