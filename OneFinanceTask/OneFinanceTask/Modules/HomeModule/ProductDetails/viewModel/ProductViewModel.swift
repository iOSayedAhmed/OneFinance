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
            .subscribe(onSuccess: { [weak self] (product:ProductModel) in
                guard let self else {return}
                productBehavior.accept(product)
            },onFailure: {[weak self] error in
                guard let self else {return}
                errorRelay.accept(error.localizedDescription)
            }).disposed(by: disposeBag)
    }
    
}
