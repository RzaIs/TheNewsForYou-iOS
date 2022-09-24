//
//  PageVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 20.09.22.
//

import UIKit
import Domain

open class PageVC<State, Effect, Service: PageService<State, Effect>>: BaseVC<State, Effect, Service>, NewsCellDelegate {
    
    func showCommentVC(newsID: String) {
        let vc = self.navigationProvider.commentVC(newsID: newsID)
        self.pushVC(vc)
    }
    
    func showWelcomeVC() {
        let vc = self.navigationProvider.welcomeVC
        self.presentVC(vc)
    }
    
    func getLikes(newsID: String) async -> [LikeEntity]? {
        await self.service.getLikes(newsID: newsID)
    }
    
    func submitLike(newsID: String) async {
        await self.service.submitLike(newsID: newsID)
    }
    
    func deleteLike(id: String) async {
        await self.service.deleteLike(id: id)
    }
    
    var isLoggedIn: Bool {
        self.service.isLoggedIn
    }
}
 
