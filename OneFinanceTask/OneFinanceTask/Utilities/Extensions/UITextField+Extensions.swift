//
//  UITextField+Extensions.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import UIKit

extension UITextField {
    
    func setPadding(left: CGFloat, right: CGFloat) {
        let paddingViewLeft = UIView(frame: CGRect(x: 0, y: 0, width: left, height: self.frame.size.height))
        self.leftView = paddingViewLeft
        self.leftViewMode = .always
        
        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: right, height: self.frame.size.height))
        self.rightView = paddingViewRight
        self.rightViewMode = .always
    }

    /// If you want to add the same amount of padding on both sides, you can use this function
    func setPadding(horizontal: CGFloat) {
        setPadding(left: horizontal, right: horizontal)
    }
}
