//
//  HomeCoordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import Foundation
import UIKit

final class HomeCoordinator:Coordinator {

    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController:UINavigationController
    var parentCoordinator:Coordinator?
    private var userData:UserData
    
    init(navigationController:UINavigationController,userData:UserData){
        self.navigationController = navigationController
        self.userData = userData
    }
    
    func start() {
        let homeViewModel = HomeViewModel(coordinator: self,networkService: BasicNetworkService(), userData: userData )
        let homeVC = HomeVC(viewModel: homeViewModel, nibName: "\(HomeVC.self)")
        navigationController.setViewControllers([homeVC], animated: true)
    }
    


    
}
