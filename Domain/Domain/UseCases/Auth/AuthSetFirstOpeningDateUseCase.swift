//
//  AuthSetFirstOpeningDateUseCase.swift
//  Domain
//
//  Created by Rza Ismayilov on 29.08.22.
//

public class AuthSetFirstOpeningDateUseCase: BaseUseCase<Date, Void> {
    
    private let repo: AuthRepoProtocol
    
    init(repo: AuthRepoProtocol) {
        self.repo = repo
    }
    
    public override func execute(input: Date) -> Void {
        self.repo.setFirstOpening(date: input)
    }
}
