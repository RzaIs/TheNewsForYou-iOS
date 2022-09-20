//
//  GetLikesUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 20.09.22.
//

public class GetLikesUseCase: BaseAsyncThrowsUseCase<String, [LikeEntity]> {
    
    private let repo: LikeRepoProtocol
    
    init(repo: LikeRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: String) async throws -> [LikeEntity] {
        try await self.repo.getLikes(newsID: input)
    }
}
