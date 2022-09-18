//
//  Domain2Remote.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import Domain

extension CommentInput {
    var toRemote: CommentBody {
        CommentBody(
            content: self.content,
            newsID: self.newsID
        )
    }
}
