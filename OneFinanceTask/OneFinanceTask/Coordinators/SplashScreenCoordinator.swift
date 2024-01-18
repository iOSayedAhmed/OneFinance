//
//  SplashScreenCoordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//



import Foundation
import UIKit


final class SplashScreenCoordinator:Coordinator {

    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController:UINavigationController
//    var parentCoordinator:OnboardingCoordinator?
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let splashScreenVC = SplashScreenVC()
        let splashScreenViewModel = SplashViewModel()
        splashScreenViewModel.coordinator = self
        splashScreenVC.viewModel = splashScreenViewModel
        navigationController.setViewControllers([splashScreenVC], animated: true)
    }
  
    func startLoginCoordinator(){
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        childCoordinators.append(loginCoordinator)
        loginCoordinator.start()
    }
    
    
    func startHomeCoordinator(){
        let homeCoordinator = HomeCoordinator(navigationController: navigationController,userData: UserData())
        childCoordinators.append(homeCoordinator)
        homeCoordinator.start()
    }
    
    func startLoginOrHome(){
        if isUserLoggedIn() {
            startHomeCoordinator()
        }else{
            startLoginCoordinator()
        }
    }
    
    
    
    func isUserLoggedIn() -> Bool {
        guard let isLoggedIn: Bool = UserDefaults.standard.getObject(forKey: .userLoggedin) else {
            return false
        }
        return isLoggedIn
    }
}
