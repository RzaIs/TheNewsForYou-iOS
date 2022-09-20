//
//  MostPopularService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 11.09.22.
//

import UIKit
import Combine
import SnapKit
import Domain

class MostPopularService: PageService<Void, MostPopularEffect> {
    
    var showSkeleton: Bool = true {
        didSet {
            self.post(effect: .reloadTable)
        }
    }
    var mostPopular: [MostPopularEntity] = [] {
        didSet {
            self.post(effect: .reloadTable)
        }
    }
    
    private let syncMostPopularUseCase: BaseAsyncThrowsUseCase<Void, Void>
    private let observeMostPopularUseCase: BaseObserveUseCase<Void, [MostPopularEntity]>
    
    init(syncMostPopularUseCase: BaseAsyncThrowsUseCase<Void, Void>,
         observeMostPopularUseCase: BaseObserveUseCase<Void, [MostPopularEntity]>,
         getLikesUseCase: BaseAsyncThrowsUseCase<String, [LikeEntity]>,
         deleteLikeUseCase: BaseAsyncThrowsUseCase<String, Void>,
         submitLikeUseCase: BaseAsyncThrowsUseCase<LikeInput, Void>,
         authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    ) {
        self.syncMostPopularUseCase = syncMostPopularUseCase
        self.observeMostPopularUseCase = observeMostPopularUseCase
        super.init(
            getLikesUseCase: getLikesUseCase,
            deleteLikeUseCase: deleteLikeUseCase,
            submitLikeUseCase: submitLikeUseCase,
            authIsLoggedInUseCase: authIsLoggedInUseCase
        )
    }
    
    func syncMostPopular() async {
        do {
            try await self.syncMostPopularUseCase.execute(input: Void())
        } catch {
            self.show(error: error)
        }
        self.showSkeleton = false
    }
    
    var observeMostPopular: AnyPublisher<[MostPopularEntity], Never> {
        self.observeMostPopularUseCase.observe(input: Void())
    }
}

enum MostPopularEffect {
    case reloadTable
}
