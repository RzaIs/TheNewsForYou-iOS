//
//  CommentTest.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain
import XCTest
import Combine
@testable import Data

class CommentTest: XCTestCase {
    
    var remoteDataSourceMock: CommentRemoteDataSourceMock!
    var repo: CommentRepo!
    
    override func setUp() {
        self.remoteDataSourceMock = .init()
        self.repo = CommentRepo(
            remoteDataSource: self.remoteDataSourceMock
        )
    }
    
    func testGetCommentsSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getCommentsResult = .success(self.remoteDataSourceMock.commentsMock)
        Task {
            do {
                let result = try await self.repo.getComments(newsID: "newsID")
                XCTAssertEqual(self.remoteDataSourceMock.commentsMock.map { $0.toDomain }, result)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.getCommentsInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testGetCommentsFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.getCommentsResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await self.repo.getComments(newsID: "newsID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.getCommentsInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitCommentSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.sendResult = .success(Void())
        Task {
            do {
                try await self.repo.submit(comment: CommentInput(content: "content", newsID: "newsID"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.sendInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitCommentFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.sendResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.submit(comment: CommentInput(content: "content", newsID: "newsID"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.sendInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteCommentSuccess() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.deleteCommentResult = .success(Void())
        Task {
            do {
                try await self.repo.deleteComment(id: "commentID")
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.deleteCommentInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteCommentFail() {
        let exp = XCTestExpectation()
        self.remoteDataSourceMock.deleteCommentResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await self.repo.deleteComment(id: "commentID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.remoteDataSourceMock.deleteCommentInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
}

extension CommentEntity: Equatable {
    public static func == (lhs: CommentEntity, rhs: CommentEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.content == rhs.content &&
        lhs.newsID == rhs.newsID &&
        lhs.isAdmin == rhs.isAdmin &&
        lhs.publishDate == rhs.publishDate &&
        lhs.author == rhs.author
    }
}

extension CommentAuthorEntity: Equatable {
    public static func == (lhs: CommentAuthorEntity, rhs: CommentAuthorEntity) -> Bool {
        lhs.id == rhs.id &&
        lhs.email == rhs.email
    }
}
