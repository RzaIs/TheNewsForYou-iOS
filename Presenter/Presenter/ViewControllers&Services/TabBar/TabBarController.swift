//
//  TabBarController.swift
//  Presenter
//
//  Created by Rza Ismayilov on 31.08.22.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    internal let service: TabBarService
    internal let navigationProvider: NavigationProviderProtocol
    
    init(service: TabBarService, navigationProvider: NavigationProviderProtocol) {
        self.service = service
        self.navigationProvider = navigationProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.title = "Top Stories"

        let topStoriesVC = self.navigationProvider.topStoriesVC
        topStoriesVC.title = "Top Stories"
        topStoriesVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "newspaper")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "newspaper.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        )
        
        let mostPopularVC = self.navigationProvider.mostPopularVC
        mostPopularVC.title = "Most Popular"
        mostPopularVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "flame")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "flame.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        )
        
        let searchArticleVC = self.navigationProvider.searchArticleVC
        searchArticleVC.title = "Search"
        searchArticleVC.tabBarItem = UITabBarItem(
            title: "",
            image: UIImage(systemName: "magnifyingglass.circle")?.withTintColor(.black, renderingMode: .alwaysOriginal),
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        )
                
        self.viewControllers = [topStoriesVC, mostPopularVC, searchArticleVC]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if self.service.isAskingForLoginNeeded() {
            let vc = self.navigationProvider.welcomeVC
            self.present(vc, animated: true) {
                self.service.setAskLogin(date: Date())
            }
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.title = viewController.title
    }
}
