//
//  AppDelegate.swift
//  TheNewsForYou
//
//  Created by Rza Ismayilov on 26.08.22.
//

import UIKit
import Swinject
import Data
import Domain
import Presenter

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
        
    var window: UIWindow?

    lazy var appAssembler: Assembler = {
        guard let infoPlist = Bundle.main.infoDictionary,
              let baseURL = infoPlist["BaseURL"] as? String,
              let keychainService = infoPlist["KeychainService"] as? String
        else {
            fatalError("info.plist not found or Environment variables not found")
        }
        
        return Assembler([
            PresenterAssembly(),
            DomainAssembly(),
            DataAssembly(
                baseURL: baseURL,
                keychainService: keychainService
            )
        ])
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
                
        let rootVC = appAssembler.resolver.resolve(UINavigationController.self)!
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

