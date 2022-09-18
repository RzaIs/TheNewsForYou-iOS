//
//  TopStoriesRemoteDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 31.08.22.
//

class TopStoryRemoteDTO: Decodable {
    let section: String
    let subsection: String
    let title: String
    let abstract: String
    let url: String
    let uri: String
    let byline: String
    let publishedDate: String
    let multimedia: [TSMultimediaRemoteDTO]?
    
    enum CodingKeys: String, CodingKey {
        case section, subsection, title, abstract, url, uri, byline, publishedDate = "published_date", multimedia
    }
}

class TSMultimediaRemoteDTO: Decodable {
    let url: String
}


