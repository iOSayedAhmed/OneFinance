//
//  AppCoordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import UIKit

protocol Coordinator:AnyObject{
    var childCoordinators:[Coordinator] {get}
    func start()
}



final class AppCoordinator:Coordinator {
    
   private(set) var childCoordinators: [Coordinator] = []
   private let navigationController = UINavigationController()

    private let window:UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        startSplashScreen()
    }
    func startSplashScreen(){
        let splashCoordinator = SplashScreenCoordinator(navigationController: navigationController)
        childCoordinators.append(splashCoordinator)
        splashCoordinator.start()
    }
    
   
    
 
    func isUserLoggedIn() -> Bool {
        guard let isLoggedIn: Bool = UserDefaults.standard.getObject(forKey: .userLoggedin) else {
            return false
        }
        return isLoggedIn
    }

    
}

