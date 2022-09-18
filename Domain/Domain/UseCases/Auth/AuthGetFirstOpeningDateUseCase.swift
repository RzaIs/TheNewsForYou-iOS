//
//  AuthGetFirstOpeningDateUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 29.08.22.
//

public class AuthGetFirstOpeningDateUseCase: BaseUseCase<Void, FirstOpeningEntity> {
    
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) -> FirstOpeningEntity {
        self.repo.getFirstOpeningDate
    }
}
