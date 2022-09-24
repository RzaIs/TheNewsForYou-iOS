//
//  LikeRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 20.09.22.
//

import Domain

class LikeRepo: LikeRepoProtocol {

    
    private let likeRemoteDataSource: LikeRemoteDataSourceProtocol
    
    init(likeRemoteDataSource: LikeRemoteDataSourceProtocol) {
        self.likeRemoteDataSource = likeRemoteDataSource
    }
    
    func getLikes(newsID: String) async throws -> [Domain.LikeEntity] {
        do {
            return try await self.likeRemoteDataSource.getLikes(newsID: newsID)
                .map { $0.toDomain }
        } catch {
            throw UIError(title: "Get Likes Error", message: "\(error.localizedDescription)\nKey: @0")
        }
    }
    
    func submit(like: LikeInput) async throws {
        do {
            try await self.likeRemoteDataSource.send(like: like.toRemote)
        } catch {
            throw UIError(title: "Get Likes Error", message: "\(error.localizedDescription)\nKey: @1")
        }
    }
    
    func deleteLike(id: String) async throws {
        do {
            try await self.likeRemoteDataSource.deleteLike(id: id)
        } catch {
            throw UIError(title: "Get Likes Error", message: "\(error.localizedDescription)\nKey: @2")
        }
    }
}
