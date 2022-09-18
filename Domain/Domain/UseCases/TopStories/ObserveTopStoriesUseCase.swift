//
//  ObserveTopStoriesUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 01.09.22.
//

import Combine

public class ObserveTopStoriesUseCase: BaseObserveUseCase<Void, [TopStoryEntity]> {
    
    private let repo: TopStoriesRepoProtocol
    
    init(repo: TopStoriesRepoProtocol) {
        self.repo = repo
    }
    
    public override func observe(input: Void) -> AnyPublisher<[TopStoryEntity], Never> {
        self.repo.observeTopStories
    }
}
