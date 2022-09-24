//
//  AuthGetUserEmailUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 24.09.22.
//

public class AuthGetUserEmailUseCase: BaseUseCase<Void, String> {
    
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) -> String {
        self.repo.userEmail
    }
}
