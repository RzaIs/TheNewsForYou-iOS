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
    let published_date: String
    let media: [MPMediaRemoteDTO]?
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
