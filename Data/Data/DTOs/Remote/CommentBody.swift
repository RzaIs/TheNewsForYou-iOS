//
//  CommentBody.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

class CommentBody: DictionaryObject {
    let content: String
    let newsID: String
    
    init(content: String, newsID: String) {
        self.content = content
        self.newsID = newsID
    }
    
    var toDictionary: [String : Any] {
        [
            "content": self.content,
            "newsID": self.newsID
        ]
    }
    
    static var collection: String {
        "comment"
    }

}
