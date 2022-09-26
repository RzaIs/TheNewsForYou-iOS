//
//  AuthRemoteDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 26.09.22.
//

import Domain
@testable import Data

class AuthRemoteDataSourceMock: AuthRemoteDataSourceProtocol {
    
    var loggedInMock: Bool = false
    
    var registerInput: AuthInput? = nil
    var registerResult: Result<Void, Error> = .success(Void())
    
    var verifyResult: Result<Void, Error> = .success(Void())
    
    var loginInput: AuthInput? = nil
    var loginResult: Result<Bool, Error> = .success(false)
    
    var logoutResult: Result<Void, Error> = .success(Void())
    
    var emailMock: String = "email@email.com"
    
    func loggedIn() -> Bool {
        self.loggedInMock
    }
    
    func register(credentials: AuthInput) async throws {
        self.registerInput = credentials
        switch self.registerResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func verify() async throws {
        switch self.verifyResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func login(credentials: AuthInput) async throws -> Bool {
        self.loginInput = credentials
        switch self.loginResult {
        case .success(let verified):
            return verified
        case .failure(let error):
            throw error
        }
    }
    
    func logout() throws {
        switch self.logoutResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func getEmail() -> String {
        self.emailMock
    }
}
