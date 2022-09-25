//
//  CommentRepoMock.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain

class CommentRepoMock: CommentRepoProtocol {
    
    var commentsMock: [CommentEntity] = [
        CommentEntity(
            id: "123456",
            content: "content",
            newsID: "newsID",
            isAdmin: true,
            publishDate: "20/08/2002",
            author: CommentAuthorEntity(
                id: "abcdefg",
                email: "email@email.com"
            )
        )
    ]
    
    var getCommentsInput: String? = nil
    var getCommentsResult: Result<[CommentEntity], Error> = .success([])
    
    var submitInput: CommentInput? = nil
    var submitResult: Result<Void, Error> = .success(Void())
    
    var deleteCommentInput: String? = nil
    var deleteCommentResult: Result<Void, Error> = .success(Void())
    
    func getComments(newsID: String) async throws -> [CommentEntity] {
        self.getCommentsInput = newsID
        switch self.getCommentsResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func submit(comment: CommentInput) async throws {
        self.submitInput = comment
        switch self.submitResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func deleteComment(id: String) async throws {
        self.deleteCommentInput = id
        switch self.deleteCommentResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
}
