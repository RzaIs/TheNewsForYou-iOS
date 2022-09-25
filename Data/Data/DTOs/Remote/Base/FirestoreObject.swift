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
    
    required init(id: String, document: [String: Any], isAdmin: Bool) {
        self.id = id
        self.isAdmin = isAdmin
    }

    class var collection: String {
        "collection"
    }
}

protocol DictionaryObject {
    var toDictionary: [String: Any] { get }
    static var collection: String { get }
}
