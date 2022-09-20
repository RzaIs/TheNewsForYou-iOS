//
//  LikeEntity.swift
//  Domain
//
//  Created by Rza Ismayilov on 20.09.22.
//

public class LikeEntity {
    public let id: String
    public let newsID: String
    public let isAdmin: Bool
    public let authorID: String
    
    public init(id: String, newsID: String, isAdmin: Bool, authorID: String) {
        self.id = id
        self.newsID = newsID
        self.isAdmin = isAdmin
        self.authorID = authorID
    }
}
