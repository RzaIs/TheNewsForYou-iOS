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
            publishDate: self.publishedDate,
            segment: segment,
            multimedia: (self.multimedia ?? []).toLocal
        )
    }
}

extension Array where Element: TSMultimediaRemoteDTO {
    var toLocal: [String] {
        var urlStrings: [String] = []
        self.forEach { multimediaRemoteDTO in
            urlStrings.append(multimediaRemoteDTO.url)
        }
        return urlStrings
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
            publishDate: self.publishedDate,
            media: (self.media ?? []).toLocal
        )
    }
}

extension Array where Element: MPMediaRemoteDTO {
    var toLocal: [String] {
        var urlStrings: [String] = []
        self.forEach { mediaRemoteDTO in
            mediaRemoteDTO.mediaMetadata.forEach { metadataRemoteDTO in
                urlStrings.append(metadataRemoteDTO.url)
            }
        }
        return urlStrings
    }
}
