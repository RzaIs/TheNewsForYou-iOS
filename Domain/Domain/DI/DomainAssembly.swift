//
//  DomainAssembly.swift
//  Domain
//
//  Created by Rza Ismayilov on 26.08.22.
//

import Swinject

public class DomainAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: Container) {
        container.register(AuthLoginUseCase.self) { r in
            AuthLoginUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthRegisterUseCase.self) { r in
            AuthRegisterUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthIsLoggedInUseCase.self) { r in
            AuthIsLoggedInUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
        
        container.register(AuthLogoutUseCase.self) { r in
            AuthLogoutUseCase(repo: r.resolve(AuthRepoProtocol.self)!)
        }
    }
}
