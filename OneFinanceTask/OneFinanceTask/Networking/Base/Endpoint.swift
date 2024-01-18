//
//  Endpoint.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import Alamofire
import CommonCrypto

protocol Endpoint:URLRequestConvertible {
    var baseURL: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var headers: HTTPHeaders? { get }
}

enum Endpoints: Endpoint {
        
    case login(parameters:Parameters)
    case allProducts
    case productDetails(id:Int)
    case addProduct(parameters:Parameters)
    case allCategories

    
    var baseURL:URL {
        return URL(string: APIURLs.baseUrl)!
    }
    
    var path:String {
        switch self {
        case .login:
            return URLPaths.login
        case .allProducts:
            return URLPaths.allProducts
        case .productDetails:
            return URLPaths.productsDetails
        case .addProduct:
            return URLPaths.addProduct
        case .allCategories:
            return URLPaths.allCategories
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .addProduct:
            return .post
        case .productDetails:
            return .get
        case .allProducts:
            return .get
        case .allCategories:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params
        case .allProducts:
            return nil
        case .productDetails:
            return nil
        case .allCategories:
            return nil
        case .addProduct(let params):
            return params
        
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .login , .allProducts ,.addProduct,.productDetails,.allCategories:
            return HTTPHeaders(["Accept":"application/json",
                                "lang":"en",
                               ])
        }
    }
    
  
        
    func asURLRequest() throws -> URLRequest {
            let url         = baseURL.appendingPathComponent(path)
            var request     = URLRequest(url: url)
            request.method  = method

        switch self {
        case .login , .allProducts ,.addProduct,.productDetails,.allCategories:
            request = try URLEncoding.default.encode(request,with: parameters)
        }
        print(request)
            return request
        }
    }
