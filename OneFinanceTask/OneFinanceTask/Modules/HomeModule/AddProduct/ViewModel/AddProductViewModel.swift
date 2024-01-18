//
//  AddProductViewModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import Foundation
import RxSwift
import RxRelay

protocol AddProductViewModelType{
   func dismissAddProduct()
    func addProduct(parametrs:[String:Any])
}

final class AddProductViewModel:AddProductViewModelType {
    
    
    
    var coordinator:AddProductCoordinator?
    var networkService:NetworkService?
    private let disposeBag = DisposeBag()
    var categories : [CategoryModel]?
    
    public let categoryBehaviorRelay = BehaviorRelay<[CategoryModel]>(value: [])
    private let addProductResultSubject = PublishSubject<AddProductModel>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
       var addProductResult: Observable<AddProductModel> {
           return addProductResultSubject.asObservable()
       }
    
    init(coordinator: AddProductCoordinator? = nil, networkService: NetworkService? = nil,categories:[CategoryModel]? = nil) {
        self.coordinator = coordinator
        self.networkService = networkService
        let updatedCategories = categories?.dropFirst().map{$0}
        self.categoryBehaviorRelay.accept(updatedCategories ?? [] )
        self.categories = categories
    }
    
    func dismissAddProduct(){
        coordinator?.dismissAddProduct()
    }
    
    func addProduct(parametrs: [String : Any]) {
        print(parametrs)
        self.isLoading.accept(true)
        networkService?.request(Endpoints.addProduct(parameters: parametrs))
            .subscribe(
                onNext: { [weak self] (productModel: AddProductModel) in
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                    self.addProductResultSubject.onNext(productModel)
                },
                onError: { [weak self] error in
                    guard let self = self else { return }
                    self.isLoading.accept(false)
                    self.addProductResultSubject.onError(error)
                    print(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    
}

