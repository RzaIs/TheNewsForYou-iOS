//
//  MostPopularEntity.swift
//  Domain
//
//  Created by Rza Ismayilov on 11.09.22.
//

public class MostPopularEntity {
    public let id: Int
    public let section: String
    public let subsection: String
    public let title: String
    public let abstract: String
    public let url: URL?
    public let author: String
    public let publishDate: PublishDateEntity
    public let media: [URL]
    
    public init(
        id: Int,
        section: String,
        subsection: String,
        title: String,
        abstract: String,
        url: URL? = nil,
        author: String,
        publishDate: PublishDateEntity,
        media: [URL]
    ) {
        self.id = id
        self.section = section
        self.subsection = subsection
        self.title = title
        self.abstract = abstract
        self.url = url
        self.author = author
        self.publishDate = publishDate
        self.media = media
    }
}
