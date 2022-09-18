//
//  TopStoryEntity.swift
//  Domain
//
//  Created by Rza Ismayilov on 01.09.22.
//

public class TopStoryEntity {
    public let id: String
    public let section: String
    public let subsection: String
    public let title: String
    public let abstract: String
    public let url: URL?
    public let author: String
    public let publishDate: PublishDateEntity
    public let segment: TopStorySegmentEntity
    public let multimedia: [URL]
    
    public init(
        id: String,
        section: String,
        subsection: String,
        title: String,
        abstract: String,
        url: URL? = nil,
        author: String,
        publishDate: PublishDateEntity,
        segment: TopStorySegmentEntity,
        multimedia: [URL]
    ) {
        self.id = id
        self.section = section
        self.subsection = subsection
        self.title = title
        self.abstract = abstract
        self.url = url
        self.author = author
        self.publishDate = publishDate
        self.segment = segment
        self.multimedia = multimedia
    }
}

public enum TopStorySegmentEntity: String {
    case home = "home"
    case arts = "arts"
    case science = "science"
    case world = "world"
    
    public var toInput: TopStoriesInput {
        switch self {
        case .home:
            return .home
        case .arts:
            return .arts
        case .science:
            return .science
        case .world:
            return .world
        }
    }
}
