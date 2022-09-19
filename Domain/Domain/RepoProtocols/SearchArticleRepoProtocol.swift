//
//  SearchArticleRepoProtocol.swift
//  Domain
//
//  Created by Rza Ismayilov on 18.09.22.
//

public protocol SearchArticleRepoProtocol {
    func search(query: String) async throws -> [SearchArticleEntity]
}
