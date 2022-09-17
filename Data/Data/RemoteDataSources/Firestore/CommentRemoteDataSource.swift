//
//  CommentRemoteDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

class CommentRemoteDataSource: CommentRemoteDataSourceProtocol {
    
    private let firebaseProvider: FirebaseProviderProtocol
    
    init(firebaseProvider: FirebaseProviderProtocol) {
        self.firebaseProvider = firebaseProvider
    }
    
    func getComment(newsID: String) async throws -> [CommentRemoteDTO] {
        try await self.firebaseProvider.getDocuments().filter { comment in
            comment.newsID == newsID
        }
    }
    
    func sendComment(comment: CommentBody) async throws {
        try await self.firebaseProvider.sendDocument(document: comment)
    }
    
    func deleteComment(id: String) async throws {
        try await self.firebaseProvider.deleteDocument(CommentRemoteDTO.self, id: id)
    }
}
