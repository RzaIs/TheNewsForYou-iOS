//
//  SyncTopStoriesUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 01.09.22.
//

public class SyncTopStoriesUseCase: BaseAsyncThrowsUseCase<TopStoriesInput, Void> {
    
    private let repo: TopStoriesRepoProtocol
    
    init(repo: TopStoriesRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: TopStoriesInput) async throws -> Void {
        try await self.repo.syncTopStories(segment: input)
    }
}
