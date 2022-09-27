//
//  CommentRDSTests.swift
//  DataTests
//
//  Created by Rza Ismayilov on 26.09.22.
//

import Domain
import XCTest
@testable import Data

class CommentRDSTests: XCTestCase {
    
    var firebaseProviderMock: FirebaseProviderMock!
    var remoteDataSource: CommentRemoteDataSource!
    
    override func setUp() {
        self.firebaseProviderMock = .init()
        self.remoteDataSource = .init(firebaseProvider: self.firebaseProviderMock)
    }
    
    func testGetCommentsSuccess() {
        let exp = XCTestExpectation()
        self.firebaseProviderMock.getDocumentsResult = .success(self.firebaseProviderMock.commentsMock)
        Task {
            do {
                let result = try await self.remoteDataSource.getComments(newsID: "newsID")
                XCTAssertEqual(result, self.firebaseProviderMock.commentsMock)
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
                _ = try await self.remoteDataSource.getComments(newsID: "newsID")
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
                try await self.remoteDataSource.deleteComment(id: "commentID")
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
                try await self.remoteDataSource.deleteComment(id: "commentID")
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
                try await self.remoteDataSource.send(comment: CommentBody(content: "content", newsID: "newsID"))
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
                try await self.remoteDataSource.send(comment: CommentBody(content: "content", newsID: "newsID"))
            } catch {
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 1.0)
    }
}

extension CommentRemoteDTO: Equatable {
    public static func == (lhs: CommentRemoteDTO, rhs: CommentRemoteDTO) -> Bool {
        lhs.id == rhs.id &&
        lhs.newsID == rhs.newsID &&
        lhs.content == rhs.content &&
        lhs.isAdmin == rhs.isAdmin &&
        lhs.authorID == rhs.authorID &&
        lhs.authorEmail == rhs.authorEmail &&
        lhs.publishDate == rhs.publishDate
    }
}
