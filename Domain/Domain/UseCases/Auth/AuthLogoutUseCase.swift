//
//  AuthLogoutUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 27.08.22.
//

public class AuthLogoutUseCase: BaseThrowsUseCase<Void, Void> {
    
    private let repo: AuthRepoProtocol

    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Void) throws -> Void {
        try self.repo.logout()
    }
}
