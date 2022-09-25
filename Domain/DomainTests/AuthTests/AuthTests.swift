//
//  AuthTests.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import XCTest
import Combine
@testable import Domain

class AuthTests: XCTestCase {
    
    var repo: AuthRepoMock!
    
    override func setUp() {
        self.repo = .init()
    }
    
    func testLoginSuccess() {
        let exp = XCTestExpectation()
        let useCase = AuthLoginUseCase(repo: self.repo)
        let verifiedMock = true
        self.repo.loginResult = .success(verifiedMock)
        Task {
            do {
                let result = try await useCase.execute(input: AuthInput(email: "email", password: "psw"))
                XCTAssertEqual(result, verifiedMock)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.loginInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLoginFail() {
        let exp = XCTestExpectation()
        let useCase = AuthLoginUseCase(repo: self.repo)
        self.repo.loginResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await useCase.execute(input: AuthInput(email: "email", password: "psw"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.loginInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRegisterSuccess() {
        let exp = XCTestExpectation()
        let useCase = AuthRegisterUseCase(repo: self.repo)
        self.repo.registerResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: AuthInput(email: "email", password: "psw"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.registerInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testRegisterFail() {
        let exp = XCTestExpectation()
        let useCase = AuthRegisterUseCase(repo: self.repo)
        self.repo.registerResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: AuthInput(email: "email", password: "psw"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.registerInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testIsLoggedIn() {
        let useCase = AuthIsLoggedInUseCase(repo: self.repo)
        
        self.repo.isLeoggedInMock = true
        let resultTrue = useCase.execute(input: Void())
        XCTAssertEqual(resultTrue, self.repo.isLeoggedInMock)
     
        self.repo.isLeoggedInMock = false
        let resultFalse = useCase.execute(input: Void())
        XCTAssertEqual(resultFalse, self.repo.isLeoggedInMock)
    }
    
    func testLogoutSuccess() {
        let exp = XCTestExpectation()
        let useCase = AuthLogoutUseCase(repo: self.repo)
        self.repo.logoutResult = .success(Void())
        do {
            try useCase.execute(input: Void())
            exp.fulfill()
        } catch {
            XCTFail()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testLogoutFail() {
        let exp = XCTestExpectation()
        let useCase = AuthLogoutUseCase(repo: self.repo)
        self.repo.logoutResult = .failure(NSError(domain: "test", code: 1))
        do {
            try useCase.execute(input: Void())
        } catch {
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testGetFirstOpenDate() {
        let useCase = AuthGetFirstOpeningDateUseCase(repo: self.repo)
        
        self.repo.getFirstOpeningDateMock = .opened(Date())
        let resultOpened = useCase.execute(input: Void())
        XCTAssertEqual(resultOpened, self.repo.getFirstOpeningDateMock)
     
        self.repo.getFirstOpeningDateMock = .notOpened
        let resultNotOpened = useCase.execute(input: Void())
        XCTAssertEqual(resultNotOpened, self.repo.getFirstOpeningDateMock)
    }
    
    func testSetFirstOpenDate() {
        let useCase = AuthSetFirstOpeningDateUseCase(repo: self.repo)
        useCase.execute(input: Date())
        XCTAssertNotNil(self.repo.setFirstOpeningInput)
    }
    
    func testGetUserEmail() {
        let useCase = AuthGetUserEmailUseCase(repo: self.repo)
        let email = useCase.execute(input: Void())
        XCTAssertEqual(email, self.repo.userEmailMock)
    }
}

extension FirstOpeningEntity: Equatable {
    public static func == (lhs: FirstOpeningEntity, rhs: FirstOpeningEntity) -> Bool {
        switch (lhs, rhs) {
        case (.opened(let date1),.opened(let date2)):
            return date1 == date2
        case (.notOpened,.notOpened):
            return true
        default:
            return false
        }
    }
}
