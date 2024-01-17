//
//  ToastManager.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//


import Foundation
import UIKit

enum ToastType {
    case error
    case message
}

class ToastManager {

    static let shared = ToastManager()
    private var view:UIView = UIView()
    private var message:String = ""
    private var backgroundColor:UIColor?
    private var errorImage:UIImage?
    private var bottomConstraint:NSLayoutConstraint!
    private var toastViews:[ToastView?] = []

    //MARK: Methods
    private init(){}

    func showToast(message:String,image:UIImage? = nil, type:ToastType ,view:UIView){
        var backGroundColor: UIColor
        var textColor: UIColor
        var messageIcon = image
        switch type {
        case .message:
            backGroundColor = .darkGray
            textColor = .white
            messageIcon = UIImage(systemName: "checkmark.seal")
        case .error:
            backGroundColor = .red
            textColor = .white
            messageIcon = UIImage(systemName: "xmark.seal")
        }
        let toastView:ToastView? = ToastView(backGroundColor: backGroundColor, textColor: textColor, icon: messageIcon)
        toastViews.forEach { hideToast(toastView: $0)}
        self.message = message
        self.view = view
        creatToastViewWithInatilPos(toastView:toastView)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3 ){[weak self] in
            self?.hideToast(toastView: toastView)
        }
            

    }


    func creatToastViewWithInatilPos(toastView:ToastView?){
        guard let toastView = toastView else {return}
        toastView.errorLabel.text = self.message
        toastView.tintColor = .white
        //add Conrner redius
        toastView.layer.cornerRadius = 10
        toastView.layer.masksToBounds = true
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        toastView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = toastView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: 300)
        bottomConstraint.isActive = true
        toastView.trailingAnchor.constraint(lessThanOrEqualTo: guide.trailingAnchor, constant: -20).isActive = true
        toastView.leadingAnchor.constraint(greaterThanOrEqualTo: guide.leadingAnchor, constant: 20).isActive = true
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastView.heightAnchor.constraint(equalToConstant: toastView.viewHeight).isActive = true
        view.layoutIfNeeded()
        animateToast()
    }

    private func animateToast(){
        if KeyboardStateManager.shared.isVisible {
            bottomConstraint.constant = -KeyboardStateManager.shared.keyboardOffset
        }else {
            bottomConstraint.constant = -20
        }
        UIView.animate(withDuration: 0.5, delay: 0.3) {[weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func hideToast(toastView:ToastView?) {
        UIView.animate(withDuration: 0.5) {
            toastView?.alpha = 0
        } completion: { (_) in
            toastView?.removeFromSuperview()
        }

    }
}



