//
//  TopStoriesLocalDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Realm
import RealmSwift

class TopStoryLocalDTO: Object {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var section: String = ""
    @Persisted var subsection: String = ""
    @Persisted var title: String = ""
    @Persisted var abstract: String = ""
    @Persisted var url: String = ""
    @Persisted var author: String = ""
    @Persisted var publishDate: String = ""
    @Persisted var segment: String = ""
    @Persisted var multimedia: List<TSMultimediaLocalDTO>
    
    convenience init(
        id: String,
        section: String,
        subsection: String,
        title: String,
        abstract: String,
        url: String,
        author: String,
        publishDate: String,
        segment: String,
        multimedia: [TSMultimediaLocalDTO]
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
        self.segment = segment
        self.multimedia.append(objectsIn: multimedia)
    }
}

class TSMultimediaLocalDTO: Object {
    @Persisted var url: String = ""
    
    convenience init(url: String) {
        self.init()
        self.url = url
    }
}
