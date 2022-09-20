//
//  DeleteLikeUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 20.09.22.
//

public class DeleteLikeUseCase: BaseAsyncThrowsUseCase<String, Void> {
    
    private let repo: LikeRepoProtocol
    
    init(repo: LikeRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> Void {
        try await self.repo.deleteLike(id: input)
    }
}
