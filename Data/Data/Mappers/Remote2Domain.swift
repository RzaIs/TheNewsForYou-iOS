//
//  Remote2Domain.swift
//  Data
//
//  Created by Rza Ismayilov on 12.09.22.
//

import Domain

extension CommentRemoteDTO {
    var toDomain: CommentEntity {
        CommentEntity(
            id: self.id,
            content: self.content,
            newsID: self.newsID,
            isAdmin: self.isAdmin,
            publishDate: self.publishDate,
            author: CommentAuthorEntity(
                id: self.authorID,
                email: self.authorEmail
            )
        )
    }
}

extension LikeRemoteDTO {
    var toDomain: LikeEntity {
        LikeEntity(
            id: self.id,
            newsID: self.newsID,
            isAdmin: self.isAdmin,
            authorID: self.authorID
        )
    }
}

extension SearchArticleRemoteDTO {
    var toDomain: SearchArticleEntity {
        SearchArticleEntity(
            id: self.uri,
            title: self.title,
            author: self.byline.original ?? "",
            abstract: self.abstract,
            sectionName: self.sectionName,
            subsectionName: self.subsectionName ?? "",
            multimedia: (self.multimedia ?? []).toDomain,
            publishDate: getDate(dateText: self.publishedDate),
            url: URL(string: self.webURL)
        )
    }
}

extension Array where Element: SDMultimediaRemoteDTO {
    var toDomain: [URL] {
        var multimedia: [URL] = []
        self.forEach { sdMultimediaRemoteDTO in
            if let url = URL(string: "https://static01.nyt.com/\(sdMultimediaRemoteDTO.url)") {
                multimedia.append(url)
            }
        }
        return multimedia
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
