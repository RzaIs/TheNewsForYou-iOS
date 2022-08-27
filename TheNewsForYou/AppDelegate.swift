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
    
    // MARK: UISceneSession Lifecycle
    
    var window: UIWindow?

    var appAssembler: Assembler!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        guard let infoPlist = Bundle.main.infoDictionary else {
            fatalError("info.plist not found")
        }
        
        guard let baseURL = infoPlist["BaseURL"] as? String,
              let APIKey = infoPlist["APIKey"] as? String,
              let keychainService = infoPlist["KeychainService"] as? String
        else {
            fatalError("Environment variables not found")
        }

        self.appAssembler = .init([
            PresenterAssembly(),
            DomainAssembly(),
            DataAssembly(
                baseURL: baseURL,
                APIKey: APIKey,
                keychainService: keychainService
            )
        ])
 
        let navigationController = appAssembler.resolver.resolve(UINavigationController.self)!
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

