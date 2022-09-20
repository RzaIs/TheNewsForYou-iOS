//
//  LikeRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 20.09.22.
//

public protocol LikeRepoProtocol {
    func getLikes(newsID: String) async throws -> [LikeEntity]
    func submit(like: LikeInput) async throws
    func deleteLike(id: String) async throws
}
