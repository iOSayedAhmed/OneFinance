//
//  SignupCoordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//



import Foundation
import UIKit

final class SignupCoordinator:Coordinator {

    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController:UINavigationController
//    var parentCoordinator:OnboardingCoordinator?
    
    init(navigationController:UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let signupViewModel = SignupViewModel(coordinator: self,networkService: BasicNetworkService())
        let signupVC = SignupVC(signupViewModel: signupViewModel, nibName: "\(SignupVC.self)")
        navigationController.pushViewController(signupVC, animated: true)

    }
    
    func startHomeCoordinator(userData:UserData){
        let homeCoordinator = HomeCoordinator(navigationController: navigationController, userData: userData)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()
    }
    
    func backToLoginCoordinator(){
        navigationController.popViewController(animated: true)
    }


    
}
