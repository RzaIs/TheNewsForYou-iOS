//
//  CommentBody.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

class CommentBody: DictionaryObject {
    let content: String
    let newsID: String
    let publishDate: String
    
    init(content: String, newsID: String) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        self.publishDate = formatter.string(from: Date())
        self.content = content
        self.newsID = newsID
    }
    
    var toDictionary: [String : Any] {
        [
            "content": self.content,
            "newsID": self.newsID,
            "publishDate": self.publishDate
        ]
    }
    
    static var collection: String {
        "comment"
    }

}
