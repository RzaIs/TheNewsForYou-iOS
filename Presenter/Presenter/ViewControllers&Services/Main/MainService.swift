//
//  MainService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Domain


public class MainService: BaseService<Void, Void> {
    
    private let authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    
    init(authIsLoggedInUseCase: BaseUseCase<Void, Bool>) {
        self.authIsLoggedInUseCase = authIsLoggedInUseCase
        let loggedIn = self.authIsLoggedInUseCase.execute(input: Void())
        print(loggedIn)
    }
    
}
