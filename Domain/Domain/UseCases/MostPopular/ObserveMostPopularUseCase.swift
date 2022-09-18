//
//  ObserveMostPopularUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 11.09.22.
//

import Combine

public class ObserveMostPopularUseCase: BaseObserveUseCase<Void, [MostPopularEntity]> {
    
    private let repo: MostPopularRepoProtocol
    
    init(repo: MostPopularRepoProtocol) {
        self.repo = repo
    }
    
    public override func observe(input: Void) -> AnyPublisher<[MostPopularEntity], Never> {
        self.repo.observeMostPopular
    }
}
