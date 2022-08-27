//
//  AuthRegisterUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

public class AuthRegisterUseCase: BaseAsyncThrowsUseCase<AuthInput, Void> {
    
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    override public func execute(input: AuthInput) async throws -> Void {
        try await self.repo.register(credentials: input)
    }
}
