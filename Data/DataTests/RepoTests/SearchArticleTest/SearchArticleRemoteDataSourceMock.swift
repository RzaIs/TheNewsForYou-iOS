//
//  SearchArticleRemoteDataSourceMock.swift
//  DataTests
//
//  Created by Rza Ismayilov on 25.09.22.
//

@testable import Data

class SearchArticleRemoteDataSourceMock: SearchArticleRemoteDataSourceProtocol {
    
    var queryMock: String = "query"
    var getSearchArticleInput: String? = nil
    var getSearchArticleResult: SearchArticleRemoteResult<SearchDataRemoteDTO> = .success(.init(data: []))
    
    func getSearchArticle(query: String) async throws -> SearchDataRemoteDTO {
        self.getSearchArticleInput = query
        switch self.getSearchArticleResult {
        case .success(let data):
            return data
        case .fail(let error):
            throw error
        }
    }
}

enum SearchArticleRemoteResult<T> {
    case success(T)
    case fail(Error)
}
