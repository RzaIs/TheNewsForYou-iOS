//
//  PresenterAssembly.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Swinject
import UIKit
import Domain

public class PresenterAssembly: Assembly {
    
    public init() { }
    
    public func assemble(container: Container) {
        container.register(NavigationProviderProtocol.self) { r in
            NavigationProvider(resolver: r)
        }
        
        container.register(MainVC.self) { r in
            MainVC(
                service: r.resolve(MainService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }
        
        container.register(MainService.self) { r in
            MainService(authIsLoggedInUseCase: r.resolve(AuthIsLoggedInUseCase.self)!)
        }
        
        container.register(UINavigationController.self) { r in
            UINavigationController(rootViewController: r.resolve(MainVC.self)!)
        }.inObjectScope(.container)
    }
}
