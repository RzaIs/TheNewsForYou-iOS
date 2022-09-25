//
//  LikeTest.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain
import XCTest
import Combine
@testable import Data

class LikeTest: XCTestCase {
    
    var remoteDataSourceMock: LikeRemoteDataSourceMock!
    var repo: LikeRepo!
    
    override func setUp() {
        self.remoteDataSourceMock = .init()
        self.repo = LikeRepo(
            likeRemoteDataSource: self.remoteDataSourceMock
        )
    }
    
    func testGetLikesSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getLikesResult = .success(self.remoteDataSourceMock.likesMock)
        Task {
            do {
                let result = try await self.repo.getLikes(newsID: "newsID")
                XCTAssertEqual(self.remoteDataSourceMock.likesMock.map { $0.toDomain }, result)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.getLikesInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testGetLikeFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getLikesResult = .failure(NSError(domain: "1234", code: 1))
        Task {
            do {
                _ = try await self.repo.getLikes(newsID: "newsID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.getLikesInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitLikeSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.sendResult = .success(Void())
        Task {
            do {
                try await self.repo.submit(like: LikeInput(newsID: "newsID"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.sendInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitLikeFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.sendResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.submit(like: LikeInput(newsID: "newsID"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.sendInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testDeleteLikeSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.deleteLikeResult = .success(Void())
        Task {
            do {
                try await self.repo.deleteLike(id: "likeID")
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.deleteLikeInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteLikeFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.deleteLikeResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.deleteLike(id: "likeID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.deleteLikeInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
}

extension LikeEntity: Equatable {
    public static func == (lhs: LikeEntity, rhs: LikeEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.newsID == rhs.newsID &&
        lhs.isAdmin == rhs.isAdmin &&
        lhs.authorID == rhs.authorID
    }
}
