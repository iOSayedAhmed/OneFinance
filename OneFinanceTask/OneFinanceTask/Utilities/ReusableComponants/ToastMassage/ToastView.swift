//
//  ToastView.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//



import UIKit

class ToastView: UIView {

    //MARK: IBOutlets
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
   
    //MARK: Proprities
    var viewHeight: CGFloat {
         let textString = (errorLabel.text ?? "") as NSString
         let textAttributes: [NSAttributedString.Key: Any] = [.font: errorLabel.font!]
         let estimatedTextHeight = textString.boundingRect(with: CGSize(width: 320, height: 2000), options: .usesLineFragmentOrigin, attributes: textAttributes, context: nil).height
         let height = estimatedTextHeight + 30
         return height
         
     }
    
    //MARK: Methods
    
    init(backGroundColor: UIColor = .red, textColor: UIColor = .white, icon: UIImage? = UIImage(systemName: "")) {
        super.init(frame: CGRect.zero)
        commonInit(backGroundColor: backGroundColor, textColor: textColor, icon: icon)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit(backGroundColor: UIColor = .red, textColor: UIColor = .white, icon: UIImage? = UIImage(systemName: "")) {
        Bundle.main.loadNibNamed("ToastView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        setupColors(color: backGroundColor, textColor: textColor, icon: icon)
    }
    
    private func setupColors(color: UIColor, textColor: UIColor, icon: UIImage?) {
        if let icon = icon {
            imageView.image = icon
        } else {
            print("error no image")
        }
        self.backgroundColor = color
        contentView.backgroundColor = color
        errorLabel.textColor = textColor
    }
}
