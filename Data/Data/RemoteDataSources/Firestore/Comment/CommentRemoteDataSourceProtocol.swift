//
//  CommentRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

protocol CommentRemoteDataSourceProtocol {
    func getComments(newsID: String) async throws -> [CommentRemoteDTO]
    func send(comment: CommentBody) async throws
    func deleteComment(id: String) async throws
}
