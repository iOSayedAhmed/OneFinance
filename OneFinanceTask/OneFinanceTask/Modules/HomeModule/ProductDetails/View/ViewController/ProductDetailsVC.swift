//
//  ProductDetails.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import UIKit
import RxSwift

class ProductDetailsVC: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: PaddedLabel!
    @IBOutlet private weak var descLabel: PaddedLabel!
    @IBOutlet private weak var priceLabel: PaddedLabel!
    @IBOutlet private weak var rateLabel: PaddedLabel!
    @IBOutlet private weak var loveButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    
    private let ViewModel:ProductDetailsViewModel!
    var cartButton = UIButton(type: .custom)
    
    private var isLoved:Bool = false
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
        ViewModel.getProductDetails()
    }

    init(viewModel:ProductDetailsViewModel,nibName:String) {
        self.ViewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    convenience required init() {
        let defaultViewModel = ProductDetailsViewModel()
        self.init(viewModel: defaultViewModel, nibName: "\(ProductDetailsVC.self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupView(){
        navigationController?.navigationBar.isHidden = true
    }
    private func setData(from product:ProductModel){
        imageView.setImageWithLoading(url: product.image ?? "")
        titleLabel.text = product.title ?? ""
        descLabel.text = product.description ?? ""
        priceLabel.text = "\(product.price ?? 0.0) EGP"
        rateLabel.text = "\(product.rating?.rate ?? 0.0)"
    }
    
    
    private func bindingViewModel(){
        ViewModel.productObservable.subscribe {[weak self] product in
            guard let self = self , let product = product else {return}
            setData(from: product)
        }.disposed(by: disposeBag)
        
        ViewModel.errorRelay.subscribe(onNext: { [weak self] errorMessage in
            guard let self else {return}
            self.handleError(errorMessage)
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe {[weak self] _ in
            guard let self else {return}
            ViewModel.coordinator?.dismissProductDetails()
        }.disposed(by: disposeBag)
        
        loveButton.rx.tap.subscribe {[weak self] _ in
            guard let self else {return}
            didTaploveButton()
        }.disposed(by: disposeBag)
    }
    
    private func handleError(_ errorMessage: String) {
        ToastManager.shared.showToast(message: errorMessage, type: .error, view: self.view)
    }
    
     func didTaploveButton() {
        isLoved.toggle()
        guard let heartFilled = UIImage(systemName: "heart.fill")?.withTintColor(.button, renderingMode: .alwaysOriginal) , let heartEmpty = UIImage(systemName: "heart")?.withTintColor(.button, renderingMode: .alwaysOriginal)else {return}
        print(isLoved)
        var image = UIImage()
        image = isLoved ? heartFilled : heartEmpty
        loveButton.setBackgroundImage(image, for: .normal)
    }

}
