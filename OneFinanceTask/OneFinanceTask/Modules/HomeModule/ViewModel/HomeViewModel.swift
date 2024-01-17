//
//  HomeViewModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
protocol HomeViewModelProtocol{
    func retriveUserData()
}

final class HomeViewModel:HomeViewModelProtocol {
    private var coordinator:HomeCoordinator?
    private var networkService:NetworkService?
            var userData:UserData?
    
    init(coordinator: HomeCoordinator? = nil, networkService: NetworkService? = nil, userData:UserData? = nil) {
        self.coordinator = coordinator
        self.networkService = networkService
        self.userData = userData
    }
    
    func retriveUserData(){
        userData = UserDefaults.standard.getCodableObject(forKey: .saveUserData)
        print(userData?.name ?? "")
    }
    
}
