//
//  CommentTests.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import XCTest
import Combine
@testable import Domain

class CommentTests: XCTestCase {
    
    var repo: CommentRepoMock!
    
    override func setUp() {
        self.repo = .init()
    }
    
    func testGetCommentsSuccess() {
        let exp = XCTestExpectation()
        let useCase = GetCommentsUseCase(repo: self.repo)
        self.repo.getCommentsResult = .success(self.repo.commentsMock)
        Task {
            do {
                let comments = try await useCase.execute(input: "newsID")
                XCTAssertEqual(comments, self.repo.commentsMock)
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.getCommentsInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testGetCommentsFail() {
        let exp = XCTestExpectation()
        let useCase = GetCommentsUseCase(repo: self.repo)
        self.repo.getCommentsResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                _ = try await useCase.execute(input: "newsID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.getCommentsInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitCommentSuccess() {
        let exp = XCTestExpectation()
        let useCase = SubmitCommentUseCase(repo: self.repo)
        self.repo.submitResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: CommentInput(content: "content", newsID: "newsID"))
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.submitInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testSubmitCommentFail() {
        let exp = XCTestExpectation()
        let useCase = SubmitCommentUseCase(repo: self.repo)
        self.repo.submitResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: CommentInput(content: "content", newsID: "newsID"))
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.submitInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteCommentSuccess() {
        let exp = XCTestExpectation()
        let useCase = DeleteCommentUseCase(repo: self.repo)
        self.repo.deleteCommentResult = .success(Void())
        Task {
            do {
                try await useCase.execute(input: "commentID")
                exp.fulfill()
            } catch {
                XCTFail()
            }
            XCTAssertNotNil(self.repo.deleteCommentInput)
        }
        wait(for: [exp], timeout: 1.0)
    }
    
    func testDeleteCommentFail() {
        let exp = XCTestExpectation()
        let useCase = DeleteCommentUseCase(repo: self.repo)
        self.repo.deleteCommentResult = .failure(NSError(domain: "test", code: 1))
        Task {
            do {
                try await useCase.execute(input: "commentID")
            } catch {
                exp.fulfill()
            }
            XCTAssertNotNil(self.repo.deleteCommentInput)
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
