//
//  Local2Domain.swift
//  Data
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Domain
import RealmSwift

extension TopStoryLocalDTO {
    var toDomain: TopStoryEntity {
        TopStoryEntity(
            id: self.id,
            section: self.section,
            subsection: self.subsection,
            title: self.title,
            abstract: self.abstract,
            url: URL(string: self.url),
            author: self.author,
            publishDate: getDate(dateText: self.publishDate),
            segment: TopStorySegmentEntity(rawValue: self.segment) ?? .home,
            multimedia: getTSMultimedia(localDTOs: self.multimedia)
        )
    }
    
    fileprivate func getTSMultimedia(localDTOs: List<TSMultimediaLocalDTO>) -> [URL] {
        var multimedia: [URL] = []
        localDTOs.forEach { localDTO in
            if let url = URL(string: localDTO.url) {
                multimedia.append(url)
            }
        }
        return multimedia
    }
}

extension MostPopularLocalDTO {
    var toDomain: MostPopularEntity {
        MostPopularEntity(
            id: self.id,
            section: self.section,
            subsection: self.subsection,
            title: self.title,
            abstract: self.abstract,
            url: URL(string: self.url),
            author: self.author,
            publishDate: getDate(dateText: self.publishDate),
            media: getMPMedia(localDTOs: self.media)
        )
    }
    
    fileprivate func getMPMedia(localDTOs: List<MPMediaLocalDTO>) -> [URL] {
        var media: [URL] = []
        localDTOs.forEach { localDTO in
            if let url = URL(string: localDTO.url) {
                media.append(url)
            }
        }
        return media
    }
}

fileprivate func getDate(dateText: String) -> PublishDateEntity {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    if let date = dateFormatter.date(from: dateText) {
        return .at(date)
    } else {
        return .unknown
    }
}
