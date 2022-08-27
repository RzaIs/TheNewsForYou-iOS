//
//  NavigationProvider.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Swinject

class NavigationProvider: NavigationProviderProtocol {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var mainVC: MainVC {
        self.resolver.resolve(MainVC.self)!
    }
}
