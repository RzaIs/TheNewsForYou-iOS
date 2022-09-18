//
//  Remote2Local.swift
//  Data
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Foundation

extension TopStoryRemoteDTO {
    func toLocal(segment: String) -> TopStoryLocalDTO {
        TopStoryLocalDTO(
            id: self.uri,
            section: self.section,
            subsection: self.subsection,
            title: self.title,
            abstract: self.abstract,
            url: self.url,
            author: self.byline,
            publishDate: self.published_date,
            segment: segment,
            multimedia: (self.multimedia ?? []).map {
                $0.toLocal
            }
        )
    }
}

extension TSMultimediaRemoteDTO {
    var toLocal: TSMultimediaLocalDTO {
        TSMultimediaLocalDTO(url: self.url)
    }
}

extension MostPopularRemoteDTO {
    var toLocal: MostPopularLocalDTO {
        MostPopularLocalDTO(
            id: self.id,
            section: self.section,
            subsection: self.subsection,
            title: self.title,
            abstract: self.abstract,
            url: self.url,
            author: self.byline,
            publishDate: self.published_date,
            media: (self.media ?? []).toLocal
        )
    }
}

extension Array where Element: MPMediaRemoteDTO {
    var toLocal: [MPMediaLocalDTO] {
        var mpMediaLocalDTO: [MPMediaLocalDTO] = []
        self.forEach { mediaRemoteDTO in
            mediaRemoteDTO.mediaMetadata.forEach { metadataRemoteDTO in
                mpMediaLocalDTO.append(
                    MPMediaLocalDTO(url: metadataRemoteDTO.url)
                )
            }
        }
        return mpMediaLocalDTO
    }
}
