//
//  UIViewController + Extensions.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//



import Foundation
import UIKit

extension UIViewController {
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8
    }
    
    func isValidName(_ name: String) -> Bool {
        return name.count <= 14
    }

    func arePasswordsEqual(_ password: String, _ confirmPassword: String) -> Bool {
        return password == confirmPassword
    }

    func isPasswordValid(_ password: String) -> Bool {
        return password.count >= 8
    }

    func isValidPhone(_ phone: String) -> Bool {
        return phone.count == 11
    }

    func showMessage(typeMessage type:ToastType,message:String){
        ToastManager.shared.showToast(message: message, type: type, view: self.view)

    }
    
    
    
}
