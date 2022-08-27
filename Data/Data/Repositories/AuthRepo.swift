//
//  AuthRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import RxRelay
import Domain

class AuthRepo: AuthRepoProtocol {
    
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    
    init(remoteDataSource: AuthRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func isLeoggedIn() -> Bool {
        self.remoteDataSource.loggedIn()
    }
    
    func login(credentials: AuthInput) async throws {
        try await self.remoteDataSource.login(credentials: credentials)
    }
    
    func logout() throws {
        try self.remoteDataSource.logout()
    }
    
    func register(credentials: AuthInput) async throws {
        try await self.register(credentials: credentials)
    }
}
