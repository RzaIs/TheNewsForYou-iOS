//
//  CommentRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import Domain

class CommentRepo: CommentRepoProtocol {
    
    private let remoteDataSource: CommentRemoteDataSourceProtocol
    
    init(remoteDataSource: CommentRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getComments(newsID: String) async throws -> [CommentEntity] {
        do {
            return try await self.remoteDataSource.getComments(newsID: newsID).map { remoteDTO in
                remoteDTO.toDomain
            }
        } catch {
            throw UIError(title: "Get Comments Error", message: "\(error.localizedDescription)\nKey: @0")
        }
    }
    
    func submit(comment: CommentInput) async throws {
        do {
            try await self.remoteDataSource.send(comment: comment.toRemote)
        } catch {
            throw UIError(title: "Submit Comments Error", message: "\(error.localizedDescription)\nKey: @1")
        }
    }
    
    func deleteComment(id: String) async throws {
        do {
            try await self.remoteDataSource.deleteComment(id: id)
        } catch {
            throw UIError(title: "Get Comments Error", message: "\(error.localizedDescription)\nKey: @2")
        }
    }
}
