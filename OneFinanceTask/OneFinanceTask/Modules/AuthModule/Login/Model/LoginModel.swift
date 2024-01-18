//
//  LoginModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import Foundation

// MARK: - LoginModel

struct LoginModel: Codable {
    let token:String?

    enum CodingKeys: String, CodingKey {
        case token
    }
}

struct UserData:Codable{
    
    
    var token : String?
    var id : Int?
    var name : String?
    
    init(token: String? = nil, id: Int? = nil, name: String? = nil) {
        self.token = token
        self.id = id
        self.name = name
    }
    
    init(){}
}


