//
//  SearchArticleUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 18.09.22.
//

public class SearchArticleUseCase: BaseAsyncThrowsUseCase<String, [SearchArticleEntity]> {
    
    private let repo: SearchArticleRepoProtocol
    
    init(repo: SearchArticleRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> [SearchArticleEntity] {
        try await self.repo.search(query: input)
    }
}
