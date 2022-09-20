//
//  PageService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 20.09.22.
//

import UIKit
import Domain

open class PageService<State, Effect>: BaseService<State, Effect> {
    
    private let getLikesUseCase: BaseAsyncThrowsUseCase<String, [LikeEntity]>
    private let deleteLikeUseCase: BaseAsyncThrowsUseCase<String, Void>
    private let submitLikeUseCase: BaseAsyncThrowsUseCase<LikeInput, Void>
    private let authIsLoggedInUseCase: BaseUseCase<Void, Bool>

    init(getLikesUseCase: BaseAsyncThrowsUseCase<String, [LikeEntity]>,
         deleteLikeUseCase: BaseAsyncThrowsUseCase<String, Void>,
         submitLikeUseCase: BaseAsyncThrowsUseCase<LikeInput, Void>,
         authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    ) {
        self.getLikesUseCase = getLikesUseCase
        self.deleteLikeUseCase = deleteLikeUseCase
        self.submitLikeUseCase = submitLikeUseCase
        self.authIsLoggedInUseCase = authIsLoggedInUseCase
    }
    
    func getLikes(newsID: String) async -> [LikeEntity]? {
        do {
            return try await self.getLikesUseCase.execute(input: newsID)
        } catch {
            self.show(error: error)
            return nil
        }
    }
    
    func deleteLike(id: String) async {
        do {
            try await self.deleteLikeUseCase.execute(input: id)
        } catch {
            self.show(error: error)
        }
    }
    
    func submitLike(newsID: String) async {
        do {
            try await self.submitLikeUseCase.execute(input: LikeInput(newsID: newsID))
        } catch {
            self.show(error: error)
        }
    }
    
    var isLoggedIn: Bool {
        self.authIsLoggedInUseCase.execute(input: Void())
    }
}
