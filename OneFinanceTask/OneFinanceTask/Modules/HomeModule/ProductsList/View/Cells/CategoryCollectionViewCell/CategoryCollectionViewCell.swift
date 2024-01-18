//
//  CategoryCollectionViewCell.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override var isSelected: Bool {
            didSet {
                setupSelectedCell()
            }
          }
        
    
    
    private func setupUI(){
        containerView.layer.cornerRadius = 12
        containerView.clipsToBounds = true
        self.containerView.layer.borderWidth = 1.0
        self.containerView.layer.borderColor = UIColor.label.cgColor
        titleLabel.textColor = .label
        titleLabel.setContentHuggingPriority(.required, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    private func setupSelectedCell(){
        self.containerView.backgroundColor = isSelected ? UIColor.button : UIColor.systemBackground
        self.titleLabel.textColor = isSelected ? UIColor.systemBackground : UIColor.label
    }
    
    func setupCell(title:String,index:Int){
        titleLabel.text = title
    }
    
}
