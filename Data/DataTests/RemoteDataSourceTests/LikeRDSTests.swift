//
//  LikeRDSTests.swift
//  DataTests
//
//  Created by Rza Ismayilov on 26.09.22.
//


import Domain
import XCTest
@testable import Data

class LikeRDSTests: XCTestCase {
    
    var firebaseProviderMock: FirebaseProviderMock!
    var remoteDataSource: LikeRemoteDataSource!
    
    override func setUp() {
        self.firebaseProviderMock = .init()
        self.remoteDataSource = .init(firebaseProvider: self.firebaseProviderMock)
    }
    
    func testGetCommentsSuccess() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.getDocumentsResult = .success(self.firebaseProviderMock.likseMock)
        Task {
            do {
                let result = try await self.remoteDataSource.getLikes(newsID: "newsID")
                XCTAssertEqual(result, self.firebaseProviderMock.likseMock)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.firebaseProviderMock.getDocumentsInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testGetCommentsFail() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.getDocumentsResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await self.remoteDataSource.getLikes(newsID: "newsID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.firebaseProviderMock.getDocumentsInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testDeleteCommentSuccess() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.deleteDocumentResult = .success(Void())
        Task {
            do {
                try await self.remoteDataSource.deleteLike(id: "commentID")
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.firebaseProviderMock.deleteDocumentInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testDeleteCommentFail() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.deleteDocumentResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.remoteDataSource.deleteLike(id: "commentID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.firebaseProviderMock.deleteDocumentInput)
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSendCommentSuccess() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.sendDocumentResult = .success(Void())
        Task {
            do {
                try await self.remoteDataSource.send(like: LikeBody(newsID: "newsID"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }

    func testSendCommentFail() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.sendDocumentResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.remoteDataSource.send(like: LikeBody(newsID: "newsID"))
            } catch {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
}

extension LikeRemoteDTO: Equatable {
    public static func == (lhs: LikeRemoteDTO, rhs: LikeRemoteDTO) -> Bool {
        lhs.id == rhs.id &&
        lhs.newsID == rhs.newsID &&
        lhs.isAdmin == rhs.isAdmin &&
        lhs.authorID == rhs.authorID
    }
}
