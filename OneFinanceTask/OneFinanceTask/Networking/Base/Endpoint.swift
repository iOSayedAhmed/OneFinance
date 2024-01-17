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
    case register(Parameters:Parameters)
    case homeCategory
    case homePopular(Parameters:Parameters)
    case homeTrending(Parameters:Parameters)

    
    var baseURL:URL {
        return URL(string: MyCashAPIURLs.baseUrl)!
    }
    
    var path:String {
        switch self {
        case .login:
            return MYCashAPIPaths.login
        case .register:
            return MYCashAPIPaths.clientRegister
        case .homeCategory:
            return MYCashAPIPaths.homeCategory
        case .homePopular:
            return MYCashAPIPaths.homePopular
        case .homeTrending:
            return MYCashAPIPaths.hometrTrending
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .register:
            return .post
        case .homeCategory:
            return .get
        case .homePopular:
            return .get
        case .homeTrending:
            return .get
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .login(let params):
            return params
        case .register(Parameters: let Params):
            return Params
        case .homeCategory:
            return nil
        case .homePopular(Parameters: let params):
            return params
        case .homeTrending(Parameters: let params):
            return params
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .login , .register ,.homeCategory,.homePopular, .homeTrending:
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
        case .login , .register, .homeCategory, .homePopular, .homeTrending:
            request = try URLEncoding.default.encode(request,with: parameters)
        }
        print(request)
            return request
        }
    }
