//
//  NetworkService.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import Alamofire
import RxSwift

enum NetworkError: Error {
    case connectivity
    case serverError(statusCode: Int)
    case parsingError
    case customError(message: String)
    
}

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T>
}

extension NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T>
    {
        return Single.create { single in
                let request = AF.request(endpoint)
                   .responseDecodable(of:T.self){ response in
                       switch response.result {
                       case .success(let data):
                           print(data)
                           single(.success(data))
                       case .failure(let error):
                           print(error)
                           single(.failure(error))
                       }
            }
            return Disposables.create()
        }

    }
    
//    func request<T: Decodable>(_ endpoint: Endpoint) -> Single<T> {
//        return Single.create { single in
//            let request = AF.request(endpoint)
//                .validate(statusCode: 200..<300)  // Status code validation
//                .responseDecodable(of: T.self) { response in
//                    switch response.result {
//                    case .success(let data):
//                        print(data)
//                        single(.success(data))
//                    case .failure(let error):
//                        
//                        if let afError = error.asAFError {
//                            switch afError {
//                            case .responseValidationFailed(reason: let reason):
//                                switch reason {
//                                case .unacceptableStatusCode(code: let code):
//                                    single(.failure(NetworkError.serverError(statusCode: code)))
//                                default:
//                                    single(.failure(NetworkError.customError(message: error.localizedDescription)))
//                                }
//                            default:
//                                single(.failure(NetworkError.customError(message: error.localizedDescription)))
//                            }
//                        } else {
//                            // Handle other errors (like connectivity)
//                            single(.failure(NetworkError.connectivity))
//                        }
//                    }
//                }
//            return Disposables.create {
//                request.cancel()
//            }
//        }
//    }
}
