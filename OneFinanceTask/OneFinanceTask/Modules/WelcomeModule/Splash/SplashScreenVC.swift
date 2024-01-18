//
//  SplashScreenVC.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import UIKit
import RxSwift

class SplashScreenVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
        //MARK: - Propreties
        var coordinator:SplashScreenCoordinator?
        var viewModel = SplashViewModel()
        private let disposeBag = DisposeBag()
        
        
        //MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            animateImageView()
            bindingViewModel()
        }
        
        //MARK: - methods
        
        private func animateImageView() {
            imageView.alpha = 0
            imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            
            UIView.animate(withDuration: 2.0, animations: {
                self.imageView.alpha = 1
                self.imageView.transform = CGAffineTransform.identity
            }) { [weak self] _ in
                self?.viewModel.animationDidFinish()
            }
        }
        
        private func bindingViewModel(){
            viewModel.animationCompleted.subscribe(onNext: {[weak self] isCompleted in
                guard let self else {return}
                isCompleted ? viewModel.coordinator?.startLoginOrHome() : print("The animation is not complete yet!")
                
            }).disposed(by: disposeBag)
        }
    
        
    }

