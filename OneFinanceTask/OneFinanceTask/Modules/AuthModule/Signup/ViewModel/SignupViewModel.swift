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
    func register(name:String,email: String,phone:String, password: String, deviceToken: String)
    func didTappedLogin()
    func didUserRegistered(userData:UserData)
}


final class SignupViewModel: SignupViewModelProtocol {
    
    private var coordinator:SignupCoordinator?
    private var networkService:NetworkService?
    private let disposeBag = DisposeBag()

    private let registerResultSubject = PublishSubject<LoginModel>()
    
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var registerResult: Observable<LoginModel> {
           return registerResultSubject.asObservable()
       }
    
    init(coordinator: SignupCoordinator? = nil, networkService: NetworkService? = nil) {
        self.coordinator = coordinator
        self.networkService = networkService
    }
    
    
    func register(name:String,email: String,phone:String, password: String, deviceToken: String) {
        isLoading.accept(true)
        guard let networkService = networkService else {
               print("NetworkService is nil")
               return
           }
        let params = ["name":name ,"email":email,"phone":phone,"password":password,"device_token":deviceToken]
        
        networkService.request(Endpoints.register(Parameters: params))
            
            .subscribe(onSuccess: { [weak self] (registerModel:LoginModel) in
                guard let self  else {return}
                self.isLoading.accept(false)
                self.registerResultSubject.onNext(registerModel)
            },onFailure: { error in
                self.isLoading.accept(false)
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func didUserRegistered(userData:UserData){
        coordinator?.startHomeCoordinator(userData: userData)
    }
    
    func didTappedLogin(){
        coordinator?.backToLoginCoordinator()
    }
    
}
