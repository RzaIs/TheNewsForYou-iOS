//
//  SubmitLikeUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 20.09.22.
//

public class SubmitLikeUseCase: BaseAsyncThrowsUseCase<LikeInput, Void> {
    
    private let repo: LikeRepoProtocol
    
    init(repo: LikeRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: LikeInput) async throws -> Void {
        try await self.repo.submit(like: input)
    }
}
