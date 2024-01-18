//
//  StyledPasswordTextField.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import UIKit

class StyledPasswordTextField: UITextField {

    // The eye button to toggle password visibility
    private let togglePasswordButton = UIButton(type: .custom)

    // Init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    // Init from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
  
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }

        override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.rightViewRect(forBounds: bounds)
            rect.origin.x -= padding.right // Move the button leftwards by the right padding amount
            return rect
        }
    
    
    private func setup() {
        // Common styling options could be applied here as well

        self.borderStyle = .none
        self.textColor = .label
//        self.layer.borderColor = Colors.borderColor?.cgColor
//        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 0.8
        
        
        // Configure the button
        togglePasswordButton.tintColor = .gray
        togglePasswordButton.setImage(UIImage(systemName:"eye")?.withRenderingMode(.alwaysTemplate), for: .normal) // Set the default eye icon
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        // Add inset (padding) to the button's content
           togglePasswordButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
           // Set a specific size for the button, considering the insets
           togglePasswordButton.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
        
        // Configure the text field
        self.isSecureTextEntry = true // Default as password field
//        self.rightView = togglePasswordButton
//        self.rightViewMode = .always // Show the toggle button always

       

    }
    
    @objc private func togglePasswordVisibility() {
        self.isSecureTextEntry = !self.isSecureTextEntry // Toggle between showing and hiding password

        // Change the button's icon based on the text visibility
        let imageName = self.isSecureTextEntry ? "eye" : "eye.slash"
        togglePasswordButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)

        // To prevent the text field from losing the current typing cursor position
        if let existingText = self.text {
            self.text?.removeAll()
            self.text = existingText
        }
        
        // Maintain the cursor position
        if let textRange = self.selectedTextRange {
            self.selectedTextRange = nil
            self.selectedTextRange = textRange
        }
    }
}
 






