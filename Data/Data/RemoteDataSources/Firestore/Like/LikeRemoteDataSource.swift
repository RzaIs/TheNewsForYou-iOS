//
//  LikeRemoteDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 20.09.22.
//

class LikeRemoteDataSource: LikeRemoteDataSourceProtocol {
    
    private let firebaseProvider: FirebaseProviderProtocol
    
    init(firebaseProvider: FirebaseProviderProtocol) {
        self.firebaseProvider = firebaseProvider
    }
    
    func getLikes(newsID: String) async throws -> [LikeRemoteDTO] {
        try await self.firebaseProvider.getDocuments(field: "newsID", value: newsID)
    }
    
    func send(like: LikeBody) async throws {
        try await self.firebaseProvider.sendDocument(document: like)
    }
    
    func deleteLike(id: String) async throws {
        try await self.firebaseProvider.deleteDocument(LikeRemoteDTO.self, id: id)
    }
}
