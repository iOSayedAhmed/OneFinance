//
//  ProductCordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//


import Foundation
import UIKit

final class ProductDetailsCoordinator:Coordinator {

    
    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController:UINavigationController
    var parentCoordinator:Coordinator?
    private var productId:Int
    
    init(navigationController:UINavigationController,productId:Int){
        self.navigationController = navigationController
        self.productId = productId
    }
    
    func start() {
        let ProductDetailsViewModel = ProductDetailsViewModel(coordinator: self,networkService: BasicNetworkService(), productId: productId)
        let productDetailsVC = ProductDetailsVC(viewModel: ProductDetailsViewModel, nibName: "\(ProductDetailsVC.self)")
        navigationController.pushViewController(productDetailsVC, animated: true)
    }
    
    func dismissProductDetails(){
        navigationController.popViewController(animated: true)
        navigationController.navigationBar.isHidden = false

    }


    
}
