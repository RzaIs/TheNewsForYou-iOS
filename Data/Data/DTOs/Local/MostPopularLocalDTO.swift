//
//  MostPopularLocalDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

import Realm
import RealmSwift

class MostPopularLocalDTO: Object {
    @Persisted(primaryKey: true) var id: Int = UUID().hashValue
    @Persisted var section: String = ""
    @Persisted var subsection: String = ""
    @Persisted var title: String = ""
    @Persisted var abstract: String = ""
    @Persisted var url: String = ""
    @Persisted var author: String = ""
    @Persisted var publishDate: String = ""
    @Persisted var media: List<MPMediaLocalDTO>
    
    convenience init(
        id: Int,
        section: String,
        subsection: String,
        title: String,
        abstract: String,
        url: String,
        author: String,
        publishDate: String,
        media: [MPMediaLocalDTO]
    ) {
        self.init()
        self.id = id
        self.section = section
        self.subsection = subsection
        self.title = title
        self.abstract = abstract
        self.url = url
        self.author = author
        self.publishDate = publishDate
        self.media.append(objectsIn: media)
    }
}

class MPMediaLocalDTO: Object {
    @Persisted var url: String = ""
    
    convenience init(url: String) {
        self.init()
        self.url = url
    }
}
