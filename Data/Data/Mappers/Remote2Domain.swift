//
//  Remote2Domain.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import Domain

extension CommentRemoteDTO {
    var toDomain: CommentEntity {
        CommentEntity(
            id: self.id,
            content: self.content,
            newsID: self.newsID,
            author: CommentAuthorEntity(
                id: self.authorID,
                email: self.authorEmail
            )
        )
    }
}
