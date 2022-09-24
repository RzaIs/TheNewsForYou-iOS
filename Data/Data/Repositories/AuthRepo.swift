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
    
    func login(credentials: AuthInput) async throws -> Bool {
        do {
            let verified = try await self.remoteDataSource.login(credentials: credentials)
            if !verified {
                try await self.remoteDataSource.verify()
                try self.remoteDataSource.logout()
            }
            return verified
        } catch {
            throw UIError(title: "Login Error", message: "\(error.localizedDescription)\nKey: @0")
        }
        
    }
    
    func logout() throws {
        do {
            try self.remoteDataSource.logout()
        } catch {
            throw UIError(title: "Logout Error", message: "\(error.localizedDescription)\nKey: @1")
        }
    }
    
    func register(credentials: AuthInput) async throws {
        do {
            try await self.remoteDataSource.register(credentials: credentials)
            try await self.remoteDataSource.verify()
            try self.remoteDataSource.logout()
        } catch {
            throw UIError(title: "Register Error", message: "\(error.localizedDescription)\nKey: @2")
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
    
    var userEmail: String {
        self.remoteDataSource.getEmail()
    }
}
