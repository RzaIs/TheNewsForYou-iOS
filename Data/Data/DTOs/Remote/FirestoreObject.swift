//
//  FirestoreObject.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import FirebaseFirestore

class FirestoreObject {
    let id: String
    
    required init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
    }
    
    init(id: String) {
        self.id = id
    }

    class var collection: String {
        "collection"
    }
}

protocol DictionaryObject {
    var toDictionary: [String: Any] { get }
    static var collection: String { get }
}
