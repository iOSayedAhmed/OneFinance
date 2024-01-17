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
    
    private let homeViewModel:HomeViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
        setupCollectionView()
        getHomeCategory()
        getHomePopular()
        getHomeTrending()
        
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
        self.navigationController?.navigationBar.prefersLargeTitles = true
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
        collectionView.register(UINib(nibName: "\(CategoryCollectionViewCell.self)", bundle: nil), forCellWithReuseIdentifier: "\(CategoryCollectionViewCell.self)")
        collectionView.collectionViewLayout = generateCollectionLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func generateCollectionLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { [weak self] (section, env) -> NSCollectionLayoutSection? in

            switch section {
            case 0 :
                return CollectionViewLayouts.shared.createCategoryCellLayout()
            default:
                return nil
            }
        }
    }
    
    private func getHomeCategory(){
        
    }
    
    private func getHomePopular(){
        
       
    }
    
    private func getHomeTrending(){
       
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

extension HomeVC : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0 : return 7
        case 1: return 8
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0 :
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CategoryCollectionViewCell.self)", for: indexPath) as? CategoryCollectionViewCell else {fatalError("Unable deque cell...")}
            if indexPath.item % 2 == 0{
                cell.setupCell(title: "heldsdsdsdsdsddssd")
            }else {
                cell.setupCell(title: "hel")
            }
            
             return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
}
