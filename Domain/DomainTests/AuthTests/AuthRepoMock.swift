//
//  AuthRepoMock.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain

class AuthRepoMock: AuthRepoProtocol {
    
    var loginInput: AuthInput? = nil
    var loginResult: Result<Bool, Error> = .success(true)
    
    var registerInput: AuthInput? = nil
    var registerResult: Result<Void, Error> = .success(Void())
    
    var logoutResult: Result<Void, Error> = .success(Void())
    var setFirstOpeningInput: Date? = nil
    var getFirstOpeningDateMock: FirstOpeningEntity = .opened(Date())
    var isLeoggedInMock = true
    var userEmailMock = "email@email.com"
    
    func login(credentials: AuthInput) async throws -> Bool {
        self.loginInput = credentials
        switch self.loginResult {
        case .success(let verified):
            return verified
        case .failure(let error):
            throw error
        }
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
    
    func logout() throws {
        switch self.logoutResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func setFirstOpening(date: Date) {
        self.setFirstOpeningInput = date
    }
    
    var getFirstOpeningDate: FirstOpeningEntity {
        self.getFirstOpeningDateMock
    }
    
    var isLeoggedIn: Bool {
        self.isLeoggedInMock
    }
    
    var userEmail: String {
        self.userEmailMock
    }
}
