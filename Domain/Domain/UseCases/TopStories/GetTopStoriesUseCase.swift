//
//  GetTopStoriesUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 10.09.22.
//

public class GetTopStoriesUseCase: BaseUseCase<TopStoriesInput, [TopStoryEntity]> {
    
    private let repo: TopStoriesRepoProtocol
    
    init(repo: TopStoriesRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: TopStoriesInput) -> [TopStoryEntity] {
        self.repo.getTopStories(segment: input)
    }
}
