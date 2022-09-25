//
//  LikeTests.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import XCTest
import Combine
@testable import Domain

class LikeTests: XCTestCase {
    
    var repo: LikeRepoMock!
    
    override func setUp() {
        self.repo = .init()
    }
    
    func testGetLikesSuccess() {
        let exp = XCTestExpectation()
        let useCase = GetLikesUseCase(repo: self.repo)
        self.repo.getLikesResult = .success(self.repo.likesMock)
        Task {
            do {
                let likes = try await useCase.execute(input: "newsID")
                XCTAssertEqual(likes, self.repo.likesMock)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.getLikesInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testGetLikesFail() {
        let exp = XCTestExpectation()
        let useCase = GetLikesUseCase(repo: self.repo)
        self.repo.getLikesResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await useCase.execute(input: "newsID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.getLikesInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSubmitLikeSuccess() {
        let exp = XCTestExpectation()
        let useCase = SubmitLikeUseCase(repo: self.repo)
        self.repo.submitResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: LikeInput(newsID: "newsID"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.submitInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitLikeFail() {
        let exp = XCTestExpectation()
        let useCase = SubmitLikeUseCase(repo: self.repo)
        self.repo.submitResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: LikeInput(newsID: "newsID"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.submitInput)
        }
        wait(for: [exp], timeout: 1.0)
    }


    func testDeleteLikeSuccess() {
        let exp = XCTestExpectation()
        let useCase = DeleteLikeUseCase(repo: self.repo)
        self.repo.deleteLikeResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: "likeID")
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.deleteLikeInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteLikeFail() {
        let exp = XCTestExpectation()
        let useCase = DeleteLikeUseCase(repo: self.repo)
        self.repo.deleteLikeResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: "likeID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.deleteLikeInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
}

extension LikeEntity: Equatable {
    public static func == (lhs: Domain.LikeEntity, rhs: Domain.LikeEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.newsID == rhs.newsID &&
        lhs.isAdmin == rhs.isAdmin &&
        lhs.authorID == rhs.authorID
    }
}
