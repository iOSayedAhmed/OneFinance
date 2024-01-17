//
//  UIView+Extensions.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import UIKit
extension UIView {
    
    @IBInspectable
        var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
            }
        }
        
        @IBInspectable var topLeft: Bool {
            get { return layer.maskedCorners.contains(.layerMinXMinYCorner) }
            set {
                if newValue {
                    layer.maskedCorners.insert(.layerMinXMinYCorner)
                } else {
                    layer.maskedCorners.remove(.layerMinXMinYCorner)
                }
            }
        }

        @IBInspectable var topRight: Bool {
            get { return layer.maskedCorners.contains(.layerMaxXMinYCorner) }
            set {
                if newValue {
                    layer.maskedCorners.insert(.layerMaxXMinYCorner)
                } else {
                    layer.maskedCorners.remove(.layerMaxXMinYCorner)
                }
            }
        }

        @IBInspectable var bottomLeft: Bool {
            get { return layer.maskedCorners.contains(.layerMinXMaxYCorner) }
            set {
                if newValue {
                    layer.maskedCorners.insert(.layerMinXMaxYCorner)
                } else {
                    layer.maskedCorners.remove(.layerMinXMaxYCorner)
                }
            }
        }

        @IBInspectable var bottomRight: Bool {
            get { return layer.maskedCorners.contains(.layerMaxXMaxYCorner) }
            set {
                if newValue {
                    layer.maskedCorners.insert(.layerMaxXMaxYCorner)
                } else {
                    layer.maskedCorners.remove(.layerMaxXMaxYCorner)
                }
            }
        }
        
        
        
        @IBInspectable
        var borderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        @IBInspectable
        var borderColor: UIColor? {
            get {
                if let color = layer.borderColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.borderColor = color.cgColor
                } else {
                    layer.borderColor = nil
                }
            }
        }
        @IBInspectable
        var shadowRadius: CGFloat {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
        }
        @IBInspectable
        var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
        }
        @IBInspectable
        var shadowOffset: CGSize {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
        }
        @IBInspectable
        var shadowColor: UIColor? {
            get {
                if let color = layer.shadowColor {
                    return UIColor(cgColor: color)
                }
                return nil
            }
            set {
                if let color = newValue {
                    layer.shadowColor = color.cgColor
                } else {
                    layer.shadowColor = nil
                }
            }
        }
    
    /// Loads a view from a nib file and adds it as a subview to the current view instance..
        func loadViewFromNib(bundle: Bundle? = nil) {
            let nibName = String(describing: Self.self)
            let bundle = Bundle(for: Self.self)
            let nib = UINib(nibName: nibName, bundle: bundle)

            guard let contentView = nib.instantiate(withOwner: self).first as? UIView else {
                assertionFailure("unable to find the content view")
                return
            }

            contentView.frame = bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            addSubview(contentView)
        }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           self.layer.cornerRadius = radius
           
           var cornerMask = CACornerMask()
           if corners.contains(.topLeft) {
               cornerMask.insert(.layerMinXMinYCorner)
           }
           if corners.contains(.topRight) {
               cornerMask.insert(.layerMaxXMinYCorner)
           }
           if corners.contains(.bottomLeft) {
               cornerMask.insert(.layerMinXMaxYCorner)
           }
           if corners.contains(.bottomRight) {
               cornerMask.insert(.layerMaxXMaxYCorner)
           }
           self.layer.maskedCorners = cornerMask
       }
    
    func applyShadow(
            color: UIColor = .black,
            alpha: Float = 0.5,
            x: CGFloat = 0,
            y: CGFloat = 2,
            blur: CGFloat = 4,
            spread: CGFloat = 0) {
            
            layer.shadowColor = color.cgColor
            layer.shadowOpacity = alpha
            layer.shadowOffset = CGSize(width: x, height: y)
            layer.shadowRadius = blur / 2.0
            
            if spread == 0 {
                layer.shadowPath = nil
            } else {
                let dx = -spread
                let rect = bounds.insetBy(dx: dx, dy: dx)
                layer.shadowPath = UIBezierPath(rect: rect).cgPath
            }
            layer.masksToBounds = false
        }
    
        func addInnerShadow() {
            let innerShadow = CALayer()
            innerShadow.frame = bounds
            
            // Shadow path (1pt ring around bounds)
            let radius = self.layer.cornerRadius
            let path = UIBezierPath(roundedRect: innerShadow.bounds.insetBy(dx: 2, dy:2), cornerRadius:radius)
            let cutout = UIBezierPath(roundedRect: innerShadow.bounds, cornerRadius:radius).reversing()
            
            path.append(cutout)
            innerShadow.shadowPath = path.cgPath
            innerShadow.masksToBounds = true
            
            // Shadow properties
            innerShadow.shadowColor = UIColor.black.cgColor
            innerShadow.shadowOffset = CGSize(width: 0, height: 0)
            innerShadow.shadowOpacity = 0.5
            innerShadow.shadowRadius = 2
            innerShadow.cornerRadius = self.layer.cornerRadius
            layer.addSublayer(innerShadow)
        }
        
        func applyInnerShadow() {
            let innerShadowLayer = CALayer()
            innerShadowLayer.frame = self.frame
            
            let radius: CGFloat = 10
            let path = UIBezierPath(roundedRect: innerShadowLayer.bounds.insetBy(dx: -9, dy: -8), cornerRadius: radius)
            let innerPath = UIBezierPath(roundedRect: innerShadowLayer.bounds, cornerRadius: radius).reversing()
            
            path.append(innerPath)
            
            innerShadowLayer.shadowPath = path.cgPath
            innerShadowLayer.masksToBounds = true
            innerShadowLayer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05).cgColor
            innerShadowLayer.shadowOffset = CGSize(width: 9, height: 8)
            innerShadowLayer.shadowOpacity = 0.7
            innerShadowLayer.shadowRadius = 5
            innerShadowLayer.cornerRadius = radius
            innerShadowLayer.cornerRadius = self.layer.cornerRadius
            innerShadowLayer.borderWidth = self.layer.borderWidth
            innerShadowLayer.borderColor = self.layer.borderColor
            
            self.layer.addSublayer(innerShadowLayer)
            self.layer.masksToBounds = true
        }
    
    func setGradiantBackground(_ colorOne:UIColor,_ colorTwo:UIColor , startPoint:CGPoint,endPoint:CGPoint){
        
        let gradiantLayer = CAGradientLayer()
        gradiantLayer.frame = bounds
        gradiantLayer.colors = [colorOne.cgColor,colorTwo.cgColor]
        gradiantLayer.cornerRadius = layer.cornerRadius
//        gradiantLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradiantLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradiantLayer.startPoint = startPoint
        gradiantLayer.endPoint = endPoint
        layer.insertSublayer(gradiantLayer, at: 0)
        
    }
}
