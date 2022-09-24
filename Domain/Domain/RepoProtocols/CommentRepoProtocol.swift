//
//  CommentRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 12.09.22.
//

public protocol CommentRepoProtocol {
    func getComments(newsID: String) async throws -> [CommentEntity]
    func submit(comment: CommentInput) async throws
    func deleteComment(id: String) async throws
}
