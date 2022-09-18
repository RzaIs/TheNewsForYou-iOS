//
//  BaseVC.swift
//  Presenter
//
//  Created by Rza Ismayilov on 27.08.22.
//

import UIKit
import Combine
import Domain

open class BaseVC<State, Effect, Service: BaseService<State, Effect>>: UIViewController {

    private var cancelBag: Set<AnyCancellable> = .init()

    internal let service: Service
    internal let navigationProvider: NavigationProviderProtocol
    
    init(service: Service, navigationProvider: NavigationProviderProtocol) {
        self.service = service
        self.navigationProvider = navigationProvider
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribe()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelBag.forEach { $0.cancel() }
        self.cancelBag.removeAll()
        self.service.cancelBag.forEach { $0.cancel() }
        self.service.cancelBag.removeAll()
    }
    
    func subscribe() {
        
        self.service.observeState.sink { state in
            self.observe(state: state)
        }.store(in: &self.cancelBag)

        self.service.observeEffect.sink { effect in
            self.observe(effect: effect)
        }.store(in: &self.cancelBag)


        self.service.observeError.sink { error in
            self.showError(error: error)
        }.store(in: &self.cancelBag)
    }
    
    internal func add(cancellable: AnyCancellable) {
        cancellable.store(in: &cancelBag)
    }
    
    internal func observe(state: State) { }
    internal func observe(effect: Effect) { }
    internal func showError(error: UIError) {
        let alert = UIAlertController(title: error.title, message: error.message, preferredStyle: .alert)
        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )
        self.present(alert, animated: true)
    }
    
    func pushVC(_ vc: UIViewController) {
        self.navigationProvider.rootNC.pushViewController(vc, animated: true)
    }
    
    func popVC() {
        self.navigationProvider.rootNC.popViewController(animated: true)
    }
    
    func presentVC(_ vc: UIViewController, completion: @escaping () -> Void = {}) {
        self.present(vc, animated: true, completion: completion)
    }
    
    func dismiss(completion: @escaping () -> Void = {}) {
        self.dismiss(animated: true, completion: completion)
    }
    
    func registerKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardDismissed),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardActivated),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
    }
    
    @objc internal func keyboardActivated(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        self.keyboardAppeared(offset: -keyboardHeight)
    }
    
    @objc internal func keyboardDismissed(notification: NSNotification) {
        self.keyboardDisappeared()
    }
    
    func keyboardAppeared(offset: CGFloat) {}
    func keyboardDisappeared() {}
}
