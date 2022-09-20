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

class MostPopularService: BaseService<Void, MostPopularEffect> {
    
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
    private let authIsLoggedInUseCase: BaseUseCase<Void, Bool>

    init(syncMostPopularUseCase: BaseAsyncThrowsUseCase<Void, Void>,
         observeMostPopularUseCase: BaseObserveUseCase<Void, [MostPopularEntity]>,
         authIsLoggedInUseCase: BaseUseCase<Void, Bool>
    ) {
        self.syncMostPopularUseCase = syncMostPopularUseCase
        self.observeMostPopularUseCase = observeMostPopularUseCase
        self.authIsLoggedInUseCase = authIsLoggedInUseCase
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
    
    var isLoggedIn: Bool {
        self.authIsLoggedInUseCase.execute(input: Void())
    }
}

enum MostPopularEffect {
    case reloadTable
}
