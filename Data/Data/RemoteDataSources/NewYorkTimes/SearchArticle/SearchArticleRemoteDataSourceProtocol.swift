//
//  SearchArticleRemoteDataSourceProtocol.swift
//  Data
//
//  Created by Rza Ismayilov on 18.09.22.
//

protocol SearchArticleRemoteDataSourceProtocol {
    func getSearchArticle(query: String) async throws -> SearchDataRemoteDTO
}
