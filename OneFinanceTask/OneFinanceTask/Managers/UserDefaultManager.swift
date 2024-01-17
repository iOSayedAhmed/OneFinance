//
//  UserdefualtManager.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import Foundation

enum UserDefaultKeys:String {
    case userLoggedin
    case userLoggedout
    case saveUserData
    
}

protocol keyValueWrapper{
    func setObject<T>(_ object:T,forKey key:UserDefaultKeys)
    func getObject<T>(forKey key:UserDefaultKeys) -> T?
    func removeObject(forKey key:UserDefaultKeys)
    
    func setCodableObject<T:Encodable>(_ object:T,forKey key:UserDefaultKeys)
    func getCodableObject<T:Decodable>(forKey key:UserDefaultKeys) -> T?
}


extension UserDefaults:keyValueWrapper{
    func removeObject(forKey key: UserDefaultKeys) {
        self.removeObject(forKey: key.rawValue)
    }
    
    func setObject<T>(_ object: T, forKey key: UserDefaultKeys) {
        setValue(object, forKey: key.rawValue)
    }
    
    func getObject<T>(forKey key: UserDefaultKeys) -> T? {
        value(forKey:key.rawValue) as? T
    }
    
    func setCodableObject<T:Encodable>(_ object: T, forKey key: UserDefaultKeys) {
        do {
            let data = try JSONEncoder().encode(object)
            setObject(data, forKey: key)
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func getCodableObject<T:Decodable>(forKey key: UserDefaultKeys) -> T? {
        guard let data:Data = getObject(forKey: key) else {return nil}
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        }catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    
}
