//
//  NavigationProviderProtocol.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import UIKit

protocol NavigationProviderProtocol {
    var rootNC: UINavigationController { get }
    var tabBarDelegate: TabBarDelegate { get }
    var welcomeVC: WelcomeVC { get }
    var authVC: AuthVC { get }
    var profileVC: ProfileVC { get }
    var topStoriesVC: TopStoriesVC { get }
    var mostPopularVC: MostPopularVC { get }
    var searchArticleVC: SearchArticleVC { get }
    func commentVC(newsID: String) -> CommentVC
}
