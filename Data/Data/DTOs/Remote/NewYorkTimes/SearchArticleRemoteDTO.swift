//
//  SearchArticleRemoteDTO.swift
//  Data
//
//  Created by Rza Ismayilov on 18.09.22.
//

class SearchDataRemoteDTO: Decodable {
    let result: [SearchArticleRemoteDTO]
    
    enum CodingKeys: String, CodingKey {
        case result = "response"
    }
    
    enum DocumentKeys: String, CodingKey {
        case docs
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nestedContainer = try container.nestedContainer(keyedBy: DocumentKeys.self, forKey: .result)
        self.result = try nestedContainer.decode([SearchArticleRemoteDTO].self, forKey: .docs)
    }
    
    init(data: [SearchArticleRemoteDTO]) {
        self.result = data
    }
}

class SearchArticleRemoteDTO: Decodable {
    let uri: String
    let title: String
    let webURL: String
    let abstract: String
    let publishedDate: String
    let sectionName: String
    let subsectionName: String?
    let multimedia: [SDMultimediaRemoteDTO]?
    let byline: SDByline
    
    enum CodingKeys: String, CodingKey {
        case uri
        case byline
        case abstract
        case multimedia
        case title = "headline"
        case webURL = "web_url"
        case sectionName = "section_name"
        case publishedDate = "pub_date"
        case subsectionName = "subsection_name"
    }
    
    enum TitleKeys: String, CodingKey {
        case headline = "main"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uri = try container.decode(String.self, forKey: .uri)
        self.byline = try container.decode(SDByline.self, forKey: .byline)
        self.abstract = try container.decode(String.self, forKey: .abstract)
        self.multimedia = try container.decodeIfPresent([SDMultimediaRemoteDTO].self, forKey: .multimedia)
        self.webURL = try container.decode(String.self, forKey: .webURL)
        self.sectionName = try container.decode(String.self, forKey: .sectionName)
        self.publishedDate = try container.decode(String.self, forKey: .publishedDate)
        self.subsectionName = try container.decodeIfPresent(String.self, forKey: .subsectionName)
        
        let headlineContainer = try container.nestedContainer(keyedBy: TitleKeys.self, forKey: .title)
        self.title = try headlineContainer.decode(String.self, forKey: .headline)
    }
}

class SDMultimediaRemoteDTO: Decodable {
    let url: String
}

class SDByline: Decodable {
    let original: String?
}
