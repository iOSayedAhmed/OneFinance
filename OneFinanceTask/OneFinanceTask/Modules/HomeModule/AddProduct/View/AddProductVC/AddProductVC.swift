//
//  AddProductVC.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import UIKit
import RxSwift
import RxCocoa

class AddProductVC: UIViewController {

    
//MARK: - IBOutlet
    
    @IBOutlet private weak var titleTextField: StyledTextField!
    @IBOutlet private weak var priceTextField: StyledTextField!
    @IBOutlet private weak var descriptionTextField: StyledTextField!
    @IBOutlet private weak var imageTextField: StyledTextField!
    @IBOutlet private weak var categoryButton: UIButton!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var AddButton: StyledButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    
    private let ViewModel:AddProductViewModel!
    private let disposeBag = DisposeBag()
    private var categoryName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindingViewModel()
        
        print(ViewModel.categories)
    }

    init(viewModel:AddProductViewModel,nibName:String) {
        self.ViewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    convenience required init() {
        let defaultViewModel = AddProductViewModel()
        self.init(viewModel: defaultViewModel, nibName: "\(AddProductVC.self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(){
        activityIndicator.hidesWhenStopped = true
    }
    
    
    
    private func bindingViewModel(){
        closeButton.rx.tap.subscribe {[weak self] _ in
            guard let self else {return}
            ViewModel.dismissAddProduct()
        }.disposed(by: disposeBag)
        
        ViewModel.categoryBehaviorRelay
            .observe(on: MainScheduler.instance)
            .bind { [weak self] categoty in
                guard let self else { return }

                setupMenuDropDown(sender: categoryButton,
                                  disposeBy: disposeBag,
                                  items: categoty) { categoty in
                    self.categoryName = categoty.title ?? ""
                    self.categoryButton.setTitle(categoty.title ?? "", for: .normal)
                    
                }
            }.disposed(by: disposeBag)
        
        ViewModel.isLoading.subscribe {[weak self] in
            guard let self else {return}
            $0 ? self.activityIndicator.startAnimating() : self.activityIndicator.stopAnimating()
        }
            .disposed(by: disposeBag)

            ViewModel.addProductResult
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] productModel in
                    guard let self else {return}
                    print("Login successful: \(productModel)")
                    if productModel.id == 21 {
                        showMessage(typeMessage: .message, message:"Added Successfully")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                            guard let self else {return}
                            ViewModel.coordinator?.dismissAddProduct()
                        }
                    }else {
                        showMessage(typeMessage: .error, message: "some thing went wrong!")
                    }
                }, onError: {[weak self] error in
                    guard let self else {return}
                    print("Login error: \(error)")
                    showMessage(typeMessage: .error, message: "\(error)")
                })
                .disposed(by: disposeBag)
        
        AddButton.rx.tap.subscribe {[weak self] _ in
            guard let self = self else { return }

               let title = titleTextField.text ?? ""
               let price = priceTextField.text ?? ""
               let description = descriptionTextField.text ?? ""
               let image = imageTextField.text ?? ""

            if title.isEmpty || price.isEmpty || description.isEmpty || image.isEmpty {
                showMessage(typeMessage: .error, message: "Please fill in all fields.")
            } else {
                let params = [
                    "title": title,
                    "price": price,
                    "description": description,
                    "image": image,
                    "category": categoryName
                ]
                
                ViewModel.addProduct(parametrs: params)
            }
        }.disposed(by: disposeBag)


        
    }

}
