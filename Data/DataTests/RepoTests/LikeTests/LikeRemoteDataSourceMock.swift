//
//  LikeRemoteDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

@testable import Data

class LikeRemoteDataSourceMock: LikeRemoteDataSourceProtocol {
    
    var getLikesInput: String? = nil
    var getLikesResult: Result<[LikeRemoteDTO], Error> = .success([])
    
    var sendInput: LikeBody? = nil
    var sendResult: Result<Void, Error> = .success(Void())
    
    var deleteLikeInput: String? = nil
    var deleteLikeResult: Result<Void, Error> = .success(Void())
    
    var likesMock: [LikeRemoteDTO] = [
        LikeRemoteDTO(id: "1234", document: [:], isAdmin: true)
    ]
    
    func getLikes(newsID: String) async throws -> [LikeRemoteDTO] {
        self.getLikesInput = newsID
        switch self.getLikesResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
    
    func send(like: LikeBody) async throws {
        self.sendInput = like
        switch self.sendResult {
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
