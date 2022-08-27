//
//  BaseVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import UIKit
import RxSwift
import RxRelay
import Domain

open class BaseVC<State, Effect, Service: BaseService<State, Effect>>: UIViewController {

    private let disposeBag: DisposeBag = .init()

    private let service: Service
    private let navigationProvider: NavigationProviderProtocol
    
    init(service: Service, navigationProvider: NavigationProviderProtocol) {
        self.service = service
        self.navigationProvider = navigationProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func subscribe() {
        self.service.observeState.subscribe(onNext: { state in
            self.observe(state: state)
        }).disposed(by: self.disposeBag)
        
        self.service.observeEffect.subscribe(onNext: { effect in
            self.observe(effect: effect)
        }).disposed(by: self.disposeBag)
        
        self.service.observeError.subscribe(onNext: { error in
            self.showError(error: error)
        }).disposed(by: self.disposeBag)
    }
    
    @MainActor func observe(state: State) { }
    @MainActor func observe(effect: Effect) { }
    @MainActor func showError(error: ErrorInfo) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        self.present(alert, animated: true)
    }
}
