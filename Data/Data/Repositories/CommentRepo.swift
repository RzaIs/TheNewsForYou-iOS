//
//  CommentRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import Domain

class CommentRepo: CommentRepoProtocol {
    
    let remoteDataSource: CommentRemoteDataSourceProtocol
    
    init(remoteDataSource: CommentRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getComments(newsID: String) async throws -> [CommentEntity] {
        try await self.remoteDataSource.getComment(newsID: newsID).map { remoteDTO in
            remoteDTO.toDomain
        }
    }
    
    func submitComment(comment: CommentInput) async throws {
        try await self.remoteDataSource.sendComment(comment: comment.toRemote)
    }
    
    func deleteComment(id: String) async throws {
        try await self.remoteDataSource.deleteComment(id: id)
    }
}
