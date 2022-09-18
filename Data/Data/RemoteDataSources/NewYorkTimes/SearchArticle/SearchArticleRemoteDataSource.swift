//
//  SearchArticleRemoteDataSource.swift
//  Data
//
//  Created by Rza Ismayilov on 18.09.22.
//

class SearchArticleRemoteDataSource: SearchArticleRemoteDataSourceProtocol {
    
    private let networkProvider: NetworkProviderProtocol
    
    init(networkProvider: NetworkProviderProtocol) {
        self.networkProvider = networkProvider
    }
    
    func getSearchArticle(query: String) async throws -> SearchDataRemoteDTO {
        try await self.networkProvider.request(
            endpoint: SearchArticleAPI.getSearchArticle.rawValue.replacingOccurrences(of: "{query}", with: query),
            method: .get,
            headers: [:],
            retry: true
        )
    }
}
