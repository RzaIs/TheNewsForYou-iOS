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
    
    func getComments(newsID: String) async throws -> [CommentRemoteDTO] {
        try await self.firebaseProvider.getDocuments(field: "newsID", value: newsID)
    }
    
    func send(comment: CommentBody) async throws {
        try await self.firebaseProvider.sendDocument(document: comment)
    }
    
    func deleteComment(id: String) async throws {
        try await self.firebaseProvider.deleteDocument(CommentRemoteDTO.self, id: id)
    }
}
