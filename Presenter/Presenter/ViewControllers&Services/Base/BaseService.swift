//
//  BaseService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Domain
import RxRelay
import RxSwift

open class BaseService<State, Effect> {
    
    private let disposeBag: DisposeBag = .init()
    
    private(set) var state: State?
    private(set) var effect: Effect?
    private(set) var error: ErrorInfo?
    
    private let stateRelay: PublishRelay<State> = .init()
    private let effectRelay: PublishRelay<Effect> = .init()
    private let errorRelay: PublishRelay<ErrorInfo> = .init()

    var observeState: Observable<State> {
        self.stateRelay.asObservable()
    }
 
    var observeEffect: Observable<Effect> {
        self.effectRelay.asObservable()
    }
    
    var observeError: Observable<ErrorInfo> {
        self.errorRelay.asObservable()
    }
    
    func post(state: State) {
        self.stateRelay.accept(state)
    }
    
    func post(effect: Effect) {
        self.effectRelay.accept(effect)
    }
    
    func show(error: Error) {
        if let error = error as? ErrorInfo {
            self.errorRelay.accept(error)
        } else {
            self.errorRelay.accept(
                ErrorInfo(
                    title: "Error",
                    message: "An unknown error occured"
                )
            )
        }
    }
}
