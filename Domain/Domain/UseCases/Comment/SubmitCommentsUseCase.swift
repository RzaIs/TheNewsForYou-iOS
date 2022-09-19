//
//  SubmitCommentsUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 19.09.22.
//

public class SubmitCommentsUseCase: BaseAsyncThrowsUseCase<CommentInput, Void> {
    
    private let repo: CommentRepoProtocol
    
    init(repo: CommentRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: CommentInput) async throws -> Void {
        try await self.repo.submitComment(comment: input)
    }
}
