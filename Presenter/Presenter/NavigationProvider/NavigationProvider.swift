//
//  NavigationProvider.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Swinject
import Domain
import UIKit

class NavigationProvider: NavigationProviderProtocol {
    
    private let resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    var rootNC: UINavigationController {
        self.resolver.resolve(UINavigationController.self)!
    }
    
    var tabBarDelegate: TabBarDelegate {
        self.resolver.resolve(TabBarController.self)!
    }
    
    var welcomeVC: WelcomeVC {
        self.resolver.resolve(WelcomeVC.self)!
    }
    
    var authVC: AuthVC {
        self.resolver.resolve(AuthVC.self)!
    }
    
    var profileVC: ProfileVC {
        self.resolver.resolve(ProfileVC.self)!
    }
    
    var topStoriesVC: TopStoriesVC {
        self.resolver.resolve(TopStoriesVC.self)!
    }
    
    var mostPopularVC: MostPopularVC {
        self.resolver.resolve(MostPopularVC.self)!
    }
    
    var searchArticleVC: SearchArticleVC {
        self.resolver.resolve(SearchArticleVC.self)!
    }
    
    func commentVC(newsID: String) -> CommentVC {
        CommentVC(
            service: CommentService(
                newsID: newsID,
                getCommentsUseCase: resolver.resolve(GetCommentsUseCase.self)!,
                deleteCommentUseCase: resolver.resolve(DeleteCommentUseCase.self)!,
                submitCommentUseCase: resolver.resolve(SubmitCommentUseCase.self)!
            ),
            navigationProvider: resolver.resolve(NavigationProviderProtocol.self)!
        )
    }
}
