//
//  SearchArticleRepo.swift
//  Data
//
//  Created by Rza Ismayilov on 18.09.22.
//

import Domain

class SearchArticleRepo: SearchArticleRepoProtocol {
    
    private let remoteDataSource: SearchArticleRemoteDataSourceProtocol
    
    init(remoteDataSource: SearchArticleRemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func search(query: String) async throws -> [SearchArticleEntity] {
        do {
            let query = query.replacingOccurrences(of: " ", with: "%20")
            return try await self.remoteDataSource.getSearchArticle(query: query)
                .result
                .filter { $0.webURL.contains("https://") }
                .map { $0.toDomain }
                .sorted { $0.publishDate > $1.publishDate }
        } catch {
            throw UIError(title: "Search Article Error", message: "\(error.localizedDescription)\nKey: @0")
        }
    }
}
