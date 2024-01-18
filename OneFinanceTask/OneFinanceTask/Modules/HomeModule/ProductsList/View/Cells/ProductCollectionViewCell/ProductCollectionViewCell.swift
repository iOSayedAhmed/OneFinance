//
//  ProductCollectionViewCell.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 18/01/2024.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI(){
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func setupCell(from Product:ProductModel){
        titleLabel.text = Product.title ?? ""
        imageView.setImageWithLoading(url: Product.image ?? "")
        rateLabel.text = "\(Product.rating?.rate ?? 0)"
        priceLabel.text = "\(Product.price ?? 0) EGP"
    }

}
