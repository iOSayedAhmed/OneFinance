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
        self.init(viewModel: defaultViewModel, nibName: "\(HomeVC.self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    private func setupView(){
        setupNavigationBar()
    }
    private func setupNavigationBar(){
        self.navigationController?.navigationBar.tintColor = UIColor.button
        
        // Create images
        let navigationRightItemImage = UIImage(systemName: "heart")?.withTintColor(.button, renderingMode: .alwaysOriginal)
        cartButton.frame = CGRect(x: 0.0, y: 0.0, width: 40, height: 40)
        cartButton.setImage(navigationRightItemImage, for: .normal)
        cartButton.addTarget(self, action: #selector(didTapCartButton), for: UIControl.Event.touchUpInside)
        let cartBarItem = UIBarButtonItem(customView: cartButton)
        
        navigationItem.rightBarButtonItems = [cartBarItem]
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
    }
    
    private func handleError(_ errorMessage: String) {
        ToastManager.shared.showToast(message: errorMessage, type: .error, view: self.view)
    }
    
    @objc func didTapCartButton() {
        isLoved.toggle()
        guard let heartFilled = UIImage(systemName: "heart.fill")?.withTintColor(.button, renderingMode: .alwaysOriginal) , let heartEmpty = UIImage(systemName: "heart")?.withTintColor(.button, renderingMode: .alwaysOriginal)else {return}
        print(isLoved)
        var image = UIImage()
        image = isLoved ? heartFilled : heartEmpty
        cartButton.setImage(image, for: .normal)
    }

}
