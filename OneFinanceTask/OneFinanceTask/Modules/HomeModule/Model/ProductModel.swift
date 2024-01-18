//
//  ProductModel.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import Foundation

struct ProductModel:Codable {
    let id:Int?
    let title:String?
    let description:String?
    let image:String?
    let price:Double?
    let rating:RatingModel?
    
}

struct RatingModel:Codable{
    let rate:Double?
    let count:Int?
}
