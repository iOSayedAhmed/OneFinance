//
//  SignupViewModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import RxSwift
import RxRelay

protocol SignupViewModelProtocol {
    func didTappedLogin()
    func didUserRegistered(userData:UserData)
}


final class SignupViewModel: SignupViewModelProtocol {
    
    private var coordinator:SignupCoordinator?
    private var networkService:NetworkService?
    private let disposeBag = DisposeBag()

    
    init(coordinator: SignupCoordinator? = nil, networkService: NetworkService? = nil) {
        self.coordinator = coordinator
        self.networkService = networkService
    }
    
    func didUserRegistered(userData:UserData){
        coordinator?.startHomeCoordinator(userData: userData)
    }
    
    func didTappedLogin(){
        coordinator?.backToLoginCoordinator()
    }
    
}
