//
//  KeyboardStateManager.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import UIKit

class KeyboardStateManager {
    static let shared = KeyboardStateManager()
    
    //MARK: Properities
    var isVisible = false
    var keyboardOffset:CGFloat = 0
    
    //MARK: Methods
    private init(){}
    
    func start() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleShow(_ notification:Notification) {
        isVisible = true
        if let keboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
            let keyboardRectangle = keboardFrame.cgRectValue
            keyboardOffset = keyboardRectangle.height
        }
    }
    
    @objc func handleHide() {
        isVisible = false
    }
    
    func stop()  {
        NotificationCenter.default.removeObserver(self)
    }
    
    
}
