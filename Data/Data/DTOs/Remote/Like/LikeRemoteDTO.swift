//
//  LikeRemoteDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 20.09.22.
//

import FirebaseFirestore

class LikeRemoteDTO: FirestoreObject {
    let newsID: String
    let authorID: String
    
    required init(document: QueryDocumentSnapshot, isAdmin: Bool) {
        self.newsID = document["newsID"] as? String ?? ""
        self.authorID = document["authorID"] as? String ?? ""
        super.init(document: document, isAdmin: isAdmin)
    }
    
    required init(id: String, document: [String : Any], isAdmin: Bool) {
        self.newsID = document["newsID"] as? String ?? ""
        self.authorID = document["authorID"] as? String ?? ""
        super.init(id: id, document: document, isAdmin: isAdmin)
    }
    
    override class var collection: String {
        "like"
    }
}
