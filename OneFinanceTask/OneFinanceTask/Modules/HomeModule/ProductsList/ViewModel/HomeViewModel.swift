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
}

final class HomeViewModel:HomeViewModelProtocol {
   
    
   
    private var coordinator:HomeCoordinator?
    private var networkService:NetworkService?
            var userData:UserData?
    
    private let disposeBag = DisposeBag()
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
            .subscribe(onSuccess: { [weak self] (categoryModel: [String]) in
              //  guard let categories = categoryModel else {return}
                var categoryModels = categoryModel.map { CategoryModel(title: $0)}
                let updatedCategory = CategoryModel(title: "All")
                categoryModels.insert(updatedCategory, at: 0)
                self?.categoryBehavior.accept(categoryModels )
            }, onFailure: { [weak self] error in
                self?.errorRelay.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
    func getAllProducts() {
        networkService?.request(Endpoints.allProducts)
            .subscribe(onSuccess: { [weak self] (products:[ProductModel]) in
                self?.productBehavior.accept(products)
            },onFailure: {[weak self] error in
                self?.errorRelay.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
}
