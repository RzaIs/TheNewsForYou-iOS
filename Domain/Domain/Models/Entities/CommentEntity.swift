//
//  CommentEntity.swift
//  Domain
//
//  Created by Rza Ismayilov on 12.09.22.
//

public class CommentEntity {
    public let id: String
    public let content: String
    public let newsID: String
    public let isAdmin: Bool
    public let publishDate: String
    public let author: CommentAuthorEntity

    public init(id: String, content: String, newsID: String, isAdmin: Bool, publishDate: String, author: CommentAuthorEntity) {
        self.id = id
        self.content = content
        self.newsID = newsID
        self.isAdmin = isAdmin
        self.publishDate = publishDate
        self.author = author
    }
    
}

public class CommentAuthorEntity {
    public let id: String
    public let email: String
    
    public init(id: String, email: String) {
        self.id = id
        self.email = email
    }
}
