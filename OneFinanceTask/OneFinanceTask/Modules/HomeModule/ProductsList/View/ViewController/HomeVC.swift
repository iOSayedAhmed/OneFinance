//
//  HomeVC.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//



import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    let addProductButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let homeViewModel:HomeViewModel!
    private let disposeBag = DisposeBag()
    
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupCollectionView()
        bindingViewModel()
        homeViewModel.getCategory()
        homeViewModel.getAllProducts()
        
    }
    
    init(viewModel:HomeViewModel,nibName:String) {
        self.homeViewModel = viewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    convenience required init() {
        let defaultViewModel = HomeViewModel()
        self.init(viewModel: defaultViewModel, nibName: "\(HomeVC.self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
   
    
   
    
    private func bindingViewModel(){
        //get all Category
        homeViewModel.categoryObservabele.bind(to: categoryCollectionView.rx.items(cellIdentifier: "\(CategoryCollectionViewCell.self)", cellType: CategoryCollectionViewCell.self)){index , model , cell in
            print(model)
            cell.setupCell(title: model.title ?? "",index:index)
            
        }.disposed(by: disposeBag)
        
        homeViewModel.productObservabele.bind(to: collectionView.rx.items(cellIdentifier: "\(ProductCollectionViewCell.self)", cellType: ProductCollectionViewCell.self)){ index , model , cell in
            cell.setupCell(from: model)
        }.disposed(by: disposeBag)
        
        homeViewModel.errorRelay.subscribe(onNext: { [weak self] errorMessage in
            guard let self else {return}
            self.handleError(errorMessage)
        }).disposed(by: disposeBag)
        
        
        categoryCollectionView.rx.modelSelected(CategoryModel.self).subscribe {[weak self] model in
            print(model)
            guard let self , let categoryName = model.element?.title else {return}
            if categoryName == "All" {
                homeViewModel.getAllProducts()
            }else{
                homeViewModel.getProductsByCategory(category: categoryName)

            }
        }.disposed(by: disposeBag)
        
        
        collectionView.rx.modelSelected(ProductModel.self).subscribe {[weak self] model in
            guard let self , let productId = model.element?.id  else {return}
            print(model.element?.id ?? 0)
            homeViewModel.showProductDetails(with: productId)
        }.disposed(by: disposeBag)
        
        //search
        searchTextField.rx.text.orEmpty
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] query in
                self?.homeViewModel.searchProducts(with: query)
            }).disposed(by: disposeBag)

    }
    
    private func handleError(_ errorMessage: String) {
        ToastManager.shared.showToast(message: errorMessage, type: .error, view: self.view)
    }
    
    @objc private func addProductButtonTapped() {
        // Handle the button tap
        print("Add Product button tapped")
        homeViewModel.showAddProduct()
    }
    
    @objc private func didTapCartButton() {
        // Handle Cart tap
        print("Go To Cart View")
    }
    
    @objc private func didTapMenuButton() {
        // Handle Menu tap
        print("Go To Menu View")
    }
    
}


//MARK: Methods For handling UI
extension HomeVC {
    
    private func setupView(){
        navigationController?.navigationBar.isHidden = false
        homeViewModel.retriveUserData()
        setupNavigationBar()
        setupAddProductButton()
        setupCustomNavigationBarItem()
    }
    
    private func setupAddProductButton(){
        view.addSubview(addProductButton)
        NSLayoutConstraint.activate([
            addProductButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            addProductButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addProductButton.widthAnchor.constraint(equalToConstant: 60),
            addProductButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        addProductButton.addTarget(self, action: #selector(addProductButtonTapped), for: .touchUpInside)
    }
    
    private func setupCustomNavigationBarItem() {
           // Create ImageView
           let imageView = UIImageView(image: UIImage(named: "Avatar"))
           imageView.contentMode = .scaleAspectFit
           imageView.translatesAutoresizingMaskIntoConstraints = false

           // Create Label
           let label = UILabel()
           label.text = "Hello, ELSayed!"
           label.textColor = .button
        label.font = .systemFont(ofSize: 15, weight: .bold)
           label.translatesAutoresizingMaskIntoConstraints = false

           // Create Container View
           let containerView = UIView()
           containerView.addSubview(imageView)
           containerView.addSubview(label)

           // Set constraints
           NSLayoutConstraint.activate([
               imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
               imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
               imageView.heightAnchor.constraint(equalToConstant: 30),
               imageView.widthAnchor.constraint(equalToConstant: 30),

               label.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
               label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
               label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
           ])

           // Create UIBarButtonItem
           let barButtonItem = UIBarButtonItem(customView: containerView)
           self.navigationItem.leftBarButtonItem = barButtonItem
       }
  
    
    private func setupNavigationBar(){
        // Create images
        let image1 = UIImage(named: "CartIcon")
        let image2 = UIImage(named: "MenuIcon")
        
        let cartButton = UIButton(type: .custom)
        cartButton.frame = CGRect(x: 0.0, y: 0.0, width: 30, height: 30)
        cartButton.setImage(image1, for: .normal)
        cartButton.addTarget(self, action: #selector(didTapCartButton), for: UIControl.Event.touchUpInside)
        
        let cartBarItem = UIBarButtonItem(customView: cartButton)
        
        let MenuBarItem = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
        MenuBarItem.setImage(image2, for: .normal)
        MenuBarItem.addTarget(self, action: #selector(didTapMenuButton), for: .touchUpInside)
        navigationItem.rightBarButtonItems = [UIBarButtonItem.init(customView: MenuBarItem),cartBarItem]
    }
    
    
    private func setupCollectionView(){
        categoryCollectionView.register(UINib(nibName: "\(CategoryCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CategoryCollectionViewCell.self)")
        collectionView.register(UINib(nibName: "\(ProductCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(ProductCollectionViewCell.self)")
        collectionView.collectionViewLayout = generateCollectionLayout()
        categoryCollectionView.collectionViewLayout = generateCategoryCollectionLayout()
    }
    
    private func generateCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, env) -> NSCollectionLayoutSection? in
            guard let self else {return nil}
            switch section {
            case 0 :
                return CollectionViewLayouts.shared.createProductCellLayout()
            default:
                return nil
            }
        }
    }
    
    private func generateCategoryCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, env) -> NSCollectionLayoutSection? in
            guard let self else {return nil}

            switch section {
            case 0 :
                return CollectionViewLayouts.shared.createCategoryCellLayout()
            default:
                return nil
            }
        }
    }
}
