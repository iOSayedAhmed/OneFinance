//
//  UIImageView + Extensions.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import SDWebImage

extension UIImageView {
    
    func setImageWithLoading(url: String){
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: "\(url)"),placeholderImage: UIImage(systemName: "photo")?.withTintColor(.secondText, renderingMode: .alwaysOriginal))
    }
}
