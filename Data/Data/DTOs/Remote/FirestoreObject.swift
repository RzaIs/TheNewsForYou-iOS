//
//  FirestoreObject.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import FirebaseFirestore

class FirestoreObject {
    let id: String
    let isAdmin: Bool
    
    required init(document: QueryDocumentSnapshot, isAdmin: Bool) {
        self.id = document.documentID
        self.isAdmin = isAdmin
    }
//    
//    init(id: String, ) {
//        self.id = id
//    }

    class var collection: String {
        "collection"
    }
}

protocol DictionaryObject {
    var toDictionary: [String: Any] { get }
    static var collection: String { get }
}
