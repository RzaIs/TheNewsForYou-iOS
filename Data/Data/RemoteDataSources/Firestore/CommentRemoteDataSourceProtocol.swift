//
//  CommentRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

protocol CommentRemoteDataSourceProtocol {
    func getComment(newsID: String) async throws -> [CommentRemoteDTO]
    func sendComment(comment: CommentBody) async throws
    func deleteComment(id: String) async throws
}
