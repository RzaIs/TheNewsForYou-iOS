//
//  CommentRemoteDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import FirebaseFirestore

class CommentRemoteDTO: FirestoreObject {
    let content: String
    let newsID: String
    let authorID: String
    let authorEmail: String
    
    required init(document: QueryDocumentSnapshot) {
        self.content = document["content"] as? String ?? ""
        self.newsID = document["newsID"] as? String ?? ""
        self.authorID = document["authorID"] as? String ?? ""
        self.authorEmail = document["authorEmail"] as? String ?? ""
        super.init(document: document)
    }
    
    override class var collection: String {
        "comment"
    }    
}
