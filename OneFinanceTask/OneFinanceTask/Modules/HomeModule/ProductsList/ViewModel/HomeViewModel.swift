//
//  HomeViewModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import RxSwift
import RxRelay


protocol HomeViewModelProtocol{
    func retriveUserData()
    func getCategory()
    func getAllProducts()
    func showProductDetails(with productId:Int)
    func getProductsByCategory(category:String)
    func showAddProduct()
    func searchProducts(with query: String)
    
}

final class HomeViewModel:HomeViewModelProtocol {
    
    
   
    private var coordinator:HomeCoordinator?
    private var networkService:NetworkService?
            var userData:UserData?
    
    private let disposeBag = DisposeBag()
    private var  categoryModels = [CategoryModel]()
    private let categoryBehavior:BehaviorRelay<[CategoryModel]> = BehaviorRelay(value: [])
    private let productBehavior : BehaviorRelay<[ProductModel]> = BehaviorRelay(value: [])
    
    let errorRelay = PublishRelay<String>()
    
    
    var categoryObservabele : Observable<[CategoryModel]> {
        return categoryBehavior.asObservable()
    }
    
    var productObservabele : Observable<[ProductModel]> {
        return productBehavior.asObservable()
    }
    
    init(coordinator: HomeCoordinator? = nil, networkService: NetworkService? = nil, userData:UserData? = nil) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.userData = userData
    }
    
    func retriveUserData(){
        userData = UserDefaults.standard.getCodableObject(forKey: .saveUserData)
        print(userData?.name ?? "")
    }
    
    func getCategory() {
        networkService?.request(Endpoints.allCategories)
            .subscribe(onNext: { [weak self] (categoryModel: [String]) in
                guard let self else {return}
                 categoryModels  = categoryModel.map { CategoryModel(title: $0) }
                let updatedCategory = CategoryModel(title: "All")
                categoryModels.insert(updatedCategory, at: 0)
                self.categoryBehavior.accept(categoryModels)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    
    func getAllProducts() {
        networkService?.request(Endpoints.allProducts)
            .subscribe(onNext: { [weak self] (products: [ProductModel]) in
                self?.productBehavior.accept(products)
            }, onError: { [weak self] error in
                self?.errorRelay.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }

    
    func showProductDetails(with productId:Int) {
        coordinator?.showProductDetails(with: productId)
    }
    func showAddProduct(){
        coordinator?.showAddProduct(with:categoryModels)
    }
    
    func getProductsByCategory(category: String) {
        networkService?.request(Endpoints.productsByCategory(category: category))
            .subscribe(onNext: { [weak self] (products: [ProductModel]) in
                // Handle the received data
                self?.productBehavior.accept(products)
            }, onError: { [weak self] error in
                // Handle any error that occurs
                self?.errorRelay.accept(error.localizedDescription)
            }, onCompleted: {
                // Optionally handle completion
            }, onDisposed: {
                // Optionally handle disposal
            }).disposed(by: disposeBag)
    }

    
    func searchProducts(with query: String) {
        guard !query.isEmpty else {
            getAllProducts()
        return
        }
        
        let filteredProducts = productBehavior.value.filter {
            $0.title?.lowercased().contains(query.lowercased()) ?? false
        }
        
        productBehavior.accept(filteredProducts)
    }

}
