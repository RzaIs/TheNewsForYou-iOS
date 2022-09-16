//
//  SyncMostPopularUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 11.09.22.
//

public class SyncMostPopularUseCase: BaseAsyncThrowsUseCase<Void, Void> {
    
    private let repo: MostPopularRepoProtocol
    
    init(repo: MostPopularRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) async throws -> Void {
        try await self.repo.syncMostPopular()
    }
}
