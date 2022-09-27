//
//  AuthTest.swift
//  DataTests
//
//  Created by Rza Ismayilov on 26.09.22.
//

import Domain
import XCTest
import Combine
@testable import Data

class AuthTest: XCTestCase {
    
    var remoteDataSourceMock: AuthRemoteDataSourceMock!
    var localDataSourceMock: AuthLocalDataSourceMock!
    var repo: AuthRepo!
    
    override func setUp() {
        self.remoteDataSourceMock = .init()
        self.localDataSourceMock = .init()
        self.repo = AuthRepo(
            remoteDataSource: self.remoteDataSourceMock,
            localDataSource: self.localDataSourceMock
        )
    }
    
    func testLoginSuccessVerified() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.loginResult = .success(true)
        self.remoteDataSourceMock.verifyResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                let result = try await self.repo.login(credentials: AuthInput(email: "email@email.com", password: "password"))
                XCTAssertTrue(result)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.loginInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLoginSuccessNotVerified() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.loginResult = .success(false)
        self.remoteDataSourceMock.verifyResult = .success(Void())
        Task {
            do {
                let result = try await self.repo.login(credentials: AuthInput(email: "email@email.com", password: "password"))
                XCTAssertFalse(result)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.loginInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLoginSuccessNotVerifiedFails() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.loginResult = .success(false)
        self.remoteDataSourceMock.verifyResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await self.repo.login(credentials: AuthInput(email: "email@email.com", password: "password"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.loginInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLoginFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.loginResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await self.repo.login(credentials: AuthInput(email: "email@email.com", password: "password"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.loginInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRegisterSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.registerResult = .success(Void())
        self.remoteDataSourceMock.verifyResult = .success(Void())
        self.remoteDataSourceMock.logoutResult = .success(Void())
        Task {
            do {
                try await self.repo.register(credentials: AuthInput(email: "email@email.com", password: "password"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.registerInput)
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRegisterSuccessVerifyFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.registerResult = .success(Void())
        self.remoteDataSourceMock.verifyResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.register(credentials: AuthInput(email: "email@email.com", password: "password"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.registerInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRegisterSuccessLogoutFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.registerResult = .success(Void())
        self.remoteDataSourceMock.verifyResult = .success(Void())
        self.remoteDataSourceMock.logoutResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.register(credentials: AuthInput(email: "email@email.com", password: "password"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.registerInput)
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLogoutSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.logoutResult = .success(Void())
        do {
            try self.repo.logout()
            exp.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLogoutFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.logoutResult = .failure(NSError(domain: "test", code: 1))
        do {
            try self.repo.logout()
        } catch {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSetFirstOpeningDate() {
        let mockDate = Date()
        self.repo.setFirstOpening(date: mockDate)
        XCTAssertEqual(mockDate, self.localDataSourceMock.setFirstOpenDateInput)
    }
    
    func testGetFirstOpeningDate() {
        self.localDataSourceMock.getFirstOpenDateMock = Date()
        let result = self.repo.getFirstOpeningDate
        
        switch result {
        case .opened(let date):
            XCTAssertEqual(date, self.localDataSourceMock.getFirstOpenDateMock)
        case .notOpened:
            XCTFail()
        }
    }
    
    func testIsLeoggedIn() {
        self.remoteDataSourceMock.loggedInMock = true
        let resultTrue = self.repo.isLeoggedIn
        XCTAssertEqual(resultTrue, self.remoteDataSourceMock.loggedInMock)
        
        self.remoteDataSourceMock.loggedInMock = false
        let resultFalse = self.repo.isLeoggedIn
        XCTAssertEqual(resultFalse, self.remoteDataSourceMock.loggedInMock)
    }
    
    func testUserEmail() {
        self.remoteDataSourceMock.emailMock = "email@email.com"
        let result = self.repo.userEmail
        XCTAssertEqual(result, self.remoteDataSourceMock.emailMock)
    }
}
