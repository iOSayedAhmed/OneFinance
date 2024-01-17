//
//  LoginModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import Foundation

// MARK: - LoginModel

struct LoginModel: Codable {
    let success: Bool?
    let responseCode: Int?
    let message: String?
    let data: UserData?

    enum CodingKeys: String, CodingKey {
        case success
        case responseCode = "response_code"
        case message, data
    }
}

// MARK: - DataClass
struct UserData: Codable {
    var id: Int?
    var name, email, phone: String?
    var image: String?
    var type, status: Int?
    var balance: String?
    var addresses: [AddressModel]?
    var token: String?
}

// MARK: - Address
struct AddressModel: Codable {
    let id: Int?
    let lat, lng: String?
    let address: String?
    let street, building, apartment: String?
    let floor, name: String?
}

