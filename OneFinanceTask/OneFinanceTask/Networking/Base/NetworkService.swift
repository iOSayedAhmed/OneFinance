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
    case Unauthorized(message:String)
    case serverError(statusCode: Int)
    case parsingError
    case customError(message: String)
    
}

protocol NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Observable<T>
}


extension NetworkService {
    func request<T: Decodable>(_ endpoint: Endpoint) -> Observable<T> {
        return Observable.create { observer in
            let request = AF.request(endpoint)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: T.self) { response in
                    switch response.result {
                    case .success(let data):
                        observer.onNext(data)
                        observer.onCompleted()
                    case .failure(let error):
                        print(error)
                        if let statusCode = response.response?.statusCode {
                            switch statusCode {
                            case 400:
                                // Handle specific status code, e.g., wrong password
                                if let data = response.data,
                                   let serverError = try? JSONDecoder().decode(ServerErrorMessage.self, from: data) {
                                    observer.onError(NetworkError.customError(message: serverError.message))
                                } else {
                                    observer.onError(NetworkError.customError(message: "username and password are not provided in JSON format"))
                                }
                            case 401:
                                if let data = response.data,
                                   let serverError = try? JSONDecoder().decode(ServerErrorMessage.self, from: data) {
                                    observer.onError(NetworkError.customError(message: serverError.message))
                                } else {
                                    observer.onError(NetworkError.Unauthorized(message: "username or password is incorrect"))
                                }
                            default:
                                observer.onError(NetworkError.customError(message: "An error occurred: \(statusCode)"))
                            }
                        } else {
                            observer.onError(NetworkError.connectivity)
                        }
                    }
                }
            return Disposables.create {
                request.cancel()
            }
        }
    }
}

struct ServerErrorMessage: Decodable {
    let message: String
}

