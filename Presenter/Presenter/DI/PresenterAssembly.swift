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
        
        container.register(UINavigationController.self) { r in
            UINavigationController(rootViewController: r.resolve(TabBarController.self)!)
        }.inObjectScope(.container)
        
        container.register(TopStoriesVC.self) { r in
            TopStoriesVC(
                service: r.resolve(TopStoriesService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }
        
        container.register(TopStoriesService.self) { r in
            TopStoriesService(
                syncTopStoriesUseCase: r.resolve(SyncTopStoriesUseCase.self)!,
                getTopStoriesUseCase: r.resolve(GetTopStoriesUseCase.self)!,
                observeTopStoriesUseCase: r.resolve(ObserveTopStoriesUseCase.self)!,
                authIsLoggedInUseCase: r.resolve(AuthIsLoggedInUseCase.self)!
            )
        }
        
        container.register(MostPopularVC.self) { r in
            MostPopularVC(
                service: r.resolve(MostPopularService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }
        
        container.register(MostPopularService.self) { r in
            MostPopularService(
                syncMostPopularUseCase: r.resolve(SyncMostPopularUseCase.self)!,
                observeMostPopularUseCase: r.resolve(ObserveMostPopularUseCase.self)!,
                authIsLoggedInUseCase: r.resolve(AuthIsLoggedInUseCase.self)!
            )
        }
        
        container.register(SearchArticleVC.self) { r in
            SearchArticleVC(
                service: r.resolve(SearchArticleService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }

        container.register(SearchArticleService.self) { r in
            SearchArticleService(
                searchArticleUseCase: r.resolve(SearchArticleUseCase.self)!,
                authIsLoggedInUseCase: r.resolve(AuthIsLoggedInUseCase.self)!
            )
        }
        
        container.register(WelcomeVC.self) { r in
            WelcomeVC(
                service: r.resolve(WelcomeService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }
        
        container.register(WelcomeService.self) { r in
            WelcomeService()
        }
        
        container.register(AuthVC.self) { r in
            AuthVC(
                service: r.resolve(AuthService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }
        
        container.register(AuthService.self) { r in
            AuthService(
                authLoginUseCase: r.resolve(AuthLoginUseCase.self)!,
                authRegisterUseCase: r.resolve(AuthRegisterUseCase.self)!
            )
        }
        
        container.register(TabBarController.self) { r in
            TabBarController(
                service: r.resolve(TabBarService.self)!,
                navigationProvider: r.resolve(NavigationProviderProtocol.self)!
            )
        }
        
        container.register(TabBarService.self) { r in
            TabBarService(
                authIsLoggedInUseCase: r.resolve(AuthIsLoggedInUseCase.self)!,
                authGetFirstOpeningDateUseCase: r.resolve(AuthGetFirstOpeningDateUseCase.self)!,
                authSetFirstOpeningDateUseCase: r.resolve(AuthSetFirstOpeningDateUseCase.self)!
            )
        }
    }
}
