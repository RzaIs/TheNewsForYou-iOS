//
//  LikeRepoMock.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain

class LikeRepoMock: LikeRepoProtocol {
    
    var likesMock: [LikeEntity] = [
        LikeEntity(
            id: "123456",
            newsID: "abcdefg",
            isAdmin: true,
            authorID: "asdfgh"
        )
    ]
    
    var getLikesInput: String? = nil
    var getLikesResult: Result<[LikeEntity], Error> = .success([])
    
    var submitInput: LikeInput? = nil
    var submitResult: Result<Void, Error> = .success(Void())
    
    var deleteLikeInput: String? = nil
    var deleteLikeResult: Result<Void, Error> = .success(Void())
    
    func getLikes(newsID: String) async throws -> [LikeEntity] {
        self.getLikesInput = newsID
        switch self.getLikesResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func submit(like: LikeInput) async throws {
        self.submitInput = like
        switch self.submitResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func deleteLike(id: String) async throws {
        self.deleteLikeInput = id
        switch self.deleteLikeResult {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
}
