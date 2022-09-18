//
//  SearchArticleEntity.swift
//  Domain
//
//  Created by Rza Ismayilov on 18.09.22.
//

public class SearchArticleEntity {
    public let id: String
    public let title: String
    public let author: String
    public let abstract: String
    public let sectionName: String
    public let subsectionName: String
    public let multimedia: [URL]
    public let publishDate: PublishDateEntity
    public let url: URL?
    
    public init(
        id: String,
        title: String,
        author: String,
        abstract: String,
        sectionName: String,
        subsectionName: String,
        multimedia: [URL],
        publishDate: PublishDateEntity,
        url: URL?
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.abstract = abstract
        self.sectionName = sectionName
        self.subsectionName = subsectionName
        self.multimedia = multimedia
        self.publishDate = publishDate
        self.url = url
    }
}
