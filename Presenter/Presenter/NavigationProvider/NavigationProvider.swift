//
//  NavigationProvider.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Swinject
import UIKit

class NavigationProvider: NavigationProviderProtocol {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var rootNC: UINavigationController {
        self.resolver.resolve(UINavigationController.self)!
    }
    
    var topStoriesVC: TopStoriesVC {
        self.resolver.resolve(TopStoriesVC.self)!
    }
    
    var mostPopularVC: MostPopularVC {
        self.resolver.resolve(MostPopularVC.self)!
    }
    
    var welcomeVC: WelcomeVC {
        self.resolver.resolve(WelcomeVC.self)!
    }
    
    var authVC: AuthVC {
        self.resolver.resolve(AuthVC.self)!
    }
}
