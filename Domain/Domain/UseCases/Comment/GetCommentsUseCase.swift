//
//  GetCommentsUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 19.09.22.
//

public class GetCommentsUseCase: BaseAsyncThrowsUseCase<String, [CommentEntity]> {
    
    private let repo: CommentRepoProtocol
    
    init(repo: CommentRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> [CommentEntity] {
        try await self.repo.getComments(newsID: input)
            .sorted { $0.publishDate > $1.publishDate }
    }
}
