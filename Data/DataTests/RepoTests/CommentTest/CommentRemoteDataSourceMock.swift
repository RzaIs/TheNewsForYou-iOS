//
//  CommentRemoteDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

@testable import Data
import FirebaseFirestore

class CommentRemoteDataSourceMock: CommentRemoteDataSourceProtocol {
    
    var getCommentsInput: String? = nil
    var getCommentsResult: Result<[CommentRemoteDTO], Error> = .success([])
    
    var sendInput: CommentBody? = nil
    var sendResult: Result<Void, Error> = .success(Void())
    
    var deleteCommentInput: String? = nil
    var deleteCommentResult: Result<Void, Error> = .success(Void())
    
    var commentsMock: [CommentRemoteDTO] = [
        CommentRemoteDTO(id: "1234", document: [:], isAdmin: true)
    ]
    
    func getComments(newsID: String) async throws -> [CommentRemoteDTO] {
        self.getCommentsInput = newsID
        switch self.getCommentsResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func send(comment: CommentBody) async throws {
        self.sendInput = comment
        switch self.sendResult {
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
