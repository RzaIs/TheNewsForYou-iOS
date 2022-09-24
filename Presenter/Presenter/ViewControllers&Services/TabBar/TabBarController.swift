//
//  TabBarController.swift
//  Presenter
//
//  Created by Rza Ismayilov on 31.08.22.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    private lazy var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle(" Login ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = FontFamily.RobotoMono.medium.font(size: 12)
        btn.backgroundColor = .systemGray6
        btn.layer.cornerRadius = 6
        btn.addTarget(self, action: #selector(showAuth), for: .touchUpInside)
        return btn
    }()
    
    private lazy var profileBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(
            UIImage(systemName: "person.circle")?
                .withTintColor(.black, renderingMode: .alwaysOriginal),
            for: .normal
        )
        btn.setTitle(" Profile ", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = FontFamily.RobotoMono.medium.font(size: 12)
        btn.backgroundColor = .systemGray6
        btn.layer.cornerRadius = 6
        btn.imageView?.snp.makeConstraints({ make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(4)
        })
        btn.addTarget(self, action: #selector(showProfile), for: .touchUpInside)
        return btn
    }()
    
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
        self.updateLoginState()
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
    
    @objc private func showProfile() {
        let vc = self.navigationProvider.profileVC
        self.present(vc, animated: true)
    }
    
    @objc private func showAuth() {
        let vc = self.navigationProvider.authVC
        self.navigationProvider.rootNC.pushViewController(vc, animated: true)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.title = viewController.title
    }
}

extension TabBarController: TabBarDelegate {
    func updateLoginState() {
        if self.service.isLoggedIn {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.profileBtn)
        } else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.loginBtn)
        }
    }
}

protocol TabBarDelegate {
    func updateLoginState()
}
