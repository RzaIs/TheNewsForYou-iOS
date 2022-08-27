//
//  AuthIsLeoggedInUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 27.08.22.
//

public class AuthIsLoggedInUseCase: BaseUseCase<Void, Bool> {
    
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    override public func execute(input: Void) -> Bool {
        self.repo.isLeoggedIn()
    }
}
