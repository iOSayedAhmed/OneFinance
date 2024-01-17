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
//        let loginViewModel = LoginViewModel()
//        loginViewModel.coordinator = self
//        splashScreenVC.viewModel = loginViewModel
        navigationController.setViewControllers([splashScreenVC], animated: true)
    }
  
}
