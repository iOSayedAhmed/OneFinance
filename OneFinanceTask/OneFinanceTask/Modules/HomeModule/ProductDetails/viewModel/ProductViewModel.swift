//
//  ProductViewModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import Foundation
import RxSwift
import RxRelay


protocol ProductDetailsViewModelType{
    func getProductDetails()
    func dismissProductDetails()
}

final class ProductDetailsViewModel:ProductDetailsViewModelType {
    
    
   
    var coordinator:ProductDetailsCoordinator?
    var networkService:NetworkService?
    private let disposeBag = DisposeBag()
    var productId : Int?
    
    private let productBehavior : BehaviorRelay<ProductModel?> = BehaviorRelay(value:nil)
    
    let errorRelay = PublishRelay<String>()
    
    var productObservable:Observable<ProductModel?> {
        return productBehavior.asObservable()
    }
    
    init(coordinator: ProductDetailsCoordinator? = nil, networkService: NetworkService? = nil,productId:Int? = nil) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.productId = productId
    }
    
    func getProductDetails() {
        networkService?.request(Endpoints.productDetails(id: productId ?? 0))
            .subscribe(onNext: { [weak self] (product: ProductModel) in
                // Handle the received data
                self?.productBehavior.accept(product)
            }, onError: { [weak self] error in
                // Handle any error that occurs
                self?.errorRelay.accept(error.localizedDescription)
            }, onCompleted: {
                // Optionally handle completion
            }, onDisposed: {
                // Optionally handle disposal
            }).disposed(by: disposeBag)
    }

    
    func dismissProductDetails() {
        coordinator?.dismissProductDetails()
    }
    
}
