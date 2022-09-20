//
//  LikeRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 20.09.22.
//

protocol LikeRemoteDataSourceProtocol {
    func getLikes(newsID: String) async throws -> [LikeRemoteDTO]
    func send(like: LikeBody) async throws
    func deleteLike(id: String) async throws
}
