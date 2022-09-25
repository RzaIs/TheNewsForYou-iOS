//
//  SearchArticleRepoMock.swift
//  DomainTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

import Domain

class SearchArticleRepoMock: SearchArticleRepoProtocol {
    
    var searchInput: String? = nil
    var searchResult: Result<[SearchArticleEntity], Error> = .success([])
    var searchDataMock: [SearchArticleEntity] = [
        SearchArticleEntity(
            id: "1234",
            title: "title",
            author: "author",
            abstract: "abstract",
            sectionName: "sectionName",
            subsectionName: "subsectionName",
            multimedia: [],
            publishDate: .at(Date()),
            url: nil
        )
    ]
    
    func search(query: String) async throws -> [SearchArticleEntity] {
        self.searchInput = query
        switch self.searchResult {
        case .success(let data):
            return data
        case .failure(let error):
            throw error
        }
    }
}
