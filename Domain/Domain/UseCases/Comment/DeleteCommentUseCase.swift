//
//  DeleteCommentUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 19.09.22.
//

public class DeleteCommentUseCase: BaseAsyncThrowsUseCase<String, Void> {
    
    private let repo: CommentRepoProtocol
    
    init(repo: CommentRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> Void {
        try await self.repo.deleteComment(id: input)
    }
}
