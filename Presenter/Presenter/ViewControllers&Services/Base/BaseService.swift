//
//  BaseService.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import Domain
import Combine

open class BaseService<State, Effect> {
    
    private let calcelBag: Set<AnyCancellable> = .init()
    
    private(set) var state: State?
    private(set) var effect: Effect?
    private(set) var error: UIError?
    
    private let stateSubject: PassthroughSubject<State, Never> = .init()
    private let effectSubject: PassthroughSubject<Effect, Never> = .init()
    private let errorSubject: PassthroughSubject<UIError, Never> = .init()

    var observeState: AnyPublisher<State, Never> {
        self.stateSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
 
    var observeEffect: AnyPublisher<Effect, Never> {
        self.effectSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    var observeError: AnyPublisher<UIError, Never> {
        self.errorSubject.receive(on: DispatchQueue.main).eraseToAnyPublisher()
    }
    
    func post(state: State) {
        self.state = state
        self.stateSubject.send(state)
    }
    
    func post(effect: Effect) {
        self.effect = effect
        self.effectSubject.send(effect)
    }
    
    func show(error: Error) {
        if let error = error as? UIError {
            self.error = error
            self.errorSubject.send(error)
        } else {
            let error =  UIError(
                title: "Error",
                message: "An unknown error occured"
            )
            self.error = error
            self.errorSubject.send(error)
        }
    }
}
