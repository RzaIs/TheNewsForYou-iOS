//
//  MostPopularRemoteDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 11.09.22.
//

class MostPopularRemoteDTO: Decodable {
    let id: Int
    let section: String
    let subsection: String
    let title: String
    let abstract: String
    let url: String
    let byline: String
    let publishedDate: String
    let media: [MPMediaRemoteDTO]?
    
    enum CodingKeys: String, CodingKey {
        case id, section, subsection, title, abstract, url, byline, publishedDate = "published_date", media
    }
}

class MPMediaRemoteDTO: Decodable {
    let mediaMetadata: [MPMediaMetadataRemoteDTO]
    
    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

class MPMediaMetadataRemoteDTO: Decodable {
    let url: String
}
