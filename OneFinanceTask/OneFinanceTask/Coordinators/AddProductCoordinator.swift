//
//  AddProductCoordinator.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import Foundation
import UIKit
final class AddProductCoordinator:Coordinator {

    private(set) var childCoordinators: [Coordinator] = []
    
    private let navigationController:UINavigationController
    weak var parentCoordinator: HomeCoordinator?
    
    private var categories:[CategoryModel]
    
    init(navigationController:UINavigationController,categories:[CategoryModel]){
        self.navigationController = navigationController
        self.categories = categories
    }
    
    func start() {
        let addProductViewModel = AddProductViewModel(coordinator: self,networkService: BasicNetworkService(), categories: categories)
        let addProductVC = AddProductVC(viewModel: addProductViewModel, nibName: "\(AddProductVC.self)")
        addProductVC.modalPresentationStyle  = .fullScreen
        addProductVC.modalTransitionStyle = .coverVertical
        navigationController.present(addProductVC, animated: true)
    }
    
    func dismissAddProduct() {
        navigationController.dismiss(animated: true)
        parentCoordinator?.childDidFinish(self)
    }

    func didDisAppear(){
        parentCoordinator?.childDidFinish(self)
    }

    
    deinit {
        print(" Coordinator Deallocted")
    }
}
