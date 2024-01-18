//
//  SplashScreenViewModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import Foundation
import RxSwift


protocol SplashViewModelType {
    func animationDidFinish()
}

final class SplashViewModel :SplashViewModelType {
   
    var coordinator:SplashScreenCoordinator?
    let animationCompleted : BehaviorSubject<Bool> =  BehaviorSubject<Bool>(value: false)

    func animationDidFinish() {
        animationCompleted.onNext(true)
    }
    
    
    
    
}
