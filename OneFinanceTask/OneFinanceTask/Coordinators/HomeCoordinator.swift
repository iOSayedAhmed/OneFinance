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
    
    func showProductDetails(with productId:Int){
        let productDetailsCoordinator = ProductDetailsCoordinator(navigationController: navigationController, productId: productId)
        productDetailsCoordinator.start()
    }
    
    func showAddProduct(with categories:[CategoryModel]){
        let addProductCoordinator = AddProductCoordinator(navigationController: navigationController, categories: categories)
        addProductCoordinator.parentCoordinator = self
        childCoordinators.append(addProductCoordinator)
        addProductCoordinator.start()
    }
    
   
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }){
            childCoordinators.remove(at: index)
        }
    }

    
}
