//
//  LoginCoordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import UIKit

final class LoginCoordinator:Coordinator {

    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController:UINavigationController
//    var parentCoordinator:OnboardingCoordinator?
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewModel = LoginViewModel(coordinator: self,networkService: BasicNetworkService())
        let loginVC = LoginVC(viewModel: loginViewModel, nibName:"\(LoginVC.self)")
        print(loginViewModel)
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func startHomeCoordinator(userData:UserData){
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, userData: userData)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
    }
    
    func startSignupCoordinator(){
        let signupCoordinator =  SignupCoordinator(navigationController: navigationController)
        signupCoordinator.start()
    }
    
}
