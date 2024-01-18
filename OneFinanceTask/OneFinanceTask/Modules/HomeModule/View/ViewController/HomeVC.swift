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
    
    private func setupView(){
        homeViewModel.retriveUserData()
        self.title = "Home"
//        self.navigationController?.navigationBar.prefersLargeTitles = true
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

            switch section {
            case 0 :
                return CollectionViewLayouts.shared.createCategoryCellLayout()
            default:
                return nil
            }
        }
    }
    
    private func bindingViewModel(){
        //get all Category
        homeViewModel.categoryObservabele.bind(to: categoryCollectionView.rx.items(cellIdentifier: "\(CategoryCollectionViewCell.self)", cellType: CategoryCollectionViewCell.self)){index , model , cell in
            cell.setupCell(title: model.title ?? "")
        }.disposed(by: disposeBag)
        
        homeViewModel.productObservabele.bind(to: collectionView.rx.items(cellIdentifier: "\(ProductCollectionViewCell.self)", cellType: ProductCollectionViewCell.self)){ index , model , cell in
            cell.setupCell(from: model)
        }.disposed(by: disposeBag)
        
        homeViewModel.errorRelay.subscribe(onNext: { [weak self] errorMessage in
            self?.handleError(errorMessage)
        }).disposed(by: disposeBag)
        
        
    }
    
    private func handleError(_ errorMessage: String) {
        ToastManager.shared.showToast(message: errorMessage, type: .error, view: self.view)
    }
    
    
    
    
   
    // Add the custom view to the stack view
    private func addCustomViewToStack() {
        
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

//extension HomeVC : UICollectionViewDataSource,UICollectionViewDelegate {
//   
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//      
//            return 60
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//      
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(ProductCollectionViewCell.self)", for: indexPath) as? ProductCollectionViewCell else {fatalError("Unable deque cell...")}
//        if indexPath.item % 2 == 0{
//            cell.setupCell(from: ProductModel(id: 1, title: "Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops", description: "dsds", image: "https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg", price: 109.87, rating: .init(rate: 4.3, count: 123)))
//        }else {
//            cell.setupCell(from: ProductModel(id: 1, title: "Mens Casual Premium Slim Fit T-Shirts", description: "dsds", image: "https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg", price: 109.87, rating: .init(rate: 4.3, count: 123)))
//        }
//        
//        return cell
//        
//      
//    }
//    
//    
//}
