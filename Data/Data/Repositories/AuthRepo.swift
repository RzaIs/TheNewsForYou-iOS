//
//  AuthRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Domain

class AuthRepo: AuthRepoProtocol {
    
    private let remoteDataSource: AuthRemoteDataSourceProtocol
    private let localDataSource: AuthLocalDataSourceProtocol
    
    init(remoteDataSource: AuthRemoteDataSourceProtocol,
         localDataSource: AuthLocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func login(credentials: AuthInput) async throws {
        do {
            try await self.remoteDataSource.login(credentials: credentials)
        } catch {
            throw UIError(title: "Login Error", message: "\(error.localizedDescription)\nKey: @0")
        }
        
    }
    
    func logout() throws {
        try self.remoteDataSource.logout()
    }
    
    func register(credentials: AuthInput) async throws {
        do {
            try await self.remoteDataSource.register(credentials: credentials)
        } catch {
            throw UIError(title: "Register Error", message: "\(error.localizedDescription)\nKey: @1")
        }
    }
    
    func setFirstOpening(date: Date) {
        self.localDataSource.setFirstOpenDate(date)
    }
    
    var isLeoggedIn: Bool {
        self.remoteDataSource.loggedIn()
    }
    
    var getFirstOpeningDate: FirstOpeningEntity {
        if let date = self.localDataSource.getFirstOpenDate {
            return .opened(date)
        } else {
            return .notOpened
        }
    }
}
