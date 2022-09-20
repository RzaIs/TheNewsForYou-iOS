//
//  LikeBody.swift
//  Data
//
//  Created by Rza Ismayilov on 20.09.22.
//

class LikeBody: DictionaryObject {
    
    let newsID: String
    
    init(newsID: String) {
        self.newsID = newsID
    }
    
    var toDictionary: [String : Any] {
        ["newsID": self.newsID]
    }
    
    static var collection: String {
        "like"
    }
}
