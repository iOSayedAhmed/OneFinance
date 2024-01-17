//
//  StyledButton.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import UIKit


class StyledButton: UIButton {
    
    // Init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtonStyles()
    }
    
    // Init from storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtonStyles()
    }
    
    
    
    func setupButtonStyles() {
        // Apply your styles here
        self.setTitleColor(.white, for: .normal)
        self.setTitleColor(.black, for: .disabled)
        self.backgroundColor = .primaryButton
        self.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        self.layer.cornerRadius = 12
       
         }

         override func layoutSubviews() {
             super.layoutSubviews()
             
         }
}
