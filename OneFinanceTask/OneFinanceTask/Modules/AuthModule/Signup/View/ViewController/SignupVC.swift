//
//  SignupVC.swift
//  OneFinanceTask
//
//  Created by iOSAYed on 17/01/2024.
//

import UIKit
import RxSwift
import RxCocoa

class SignupVC: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var mainStackView: UIStackView!
    @IBOutlet private weak var topView: UIView!
    @IBOutlet private weak var nameTextField: StyledTextField!
    @IBOutlet private weak var emailTextField: StyledTextField!
    @IBOutlet private weak var phoneNumberTextField: StyledTextField!
    @IBOutlet private weak var passwordTextField: StyledPasswordTextField!
    @IBOutlet private weak var confirmPasswordTextField: StyledPasswordTextField!
    @IBOutlet private weak var spacerView: UIView!
    @IBOutlet private weak var signupButton: StyledButton!
    @IBOutlet private weak var loginButton: UIButton!
    @IBOutlet private weak var activityIndecator: UIActivityIndicatorView!
    @IBOutlet private weak var togglePasswordButton: UIButton!
    @IBOutlet private weak var toggleConfirmPasswordButton: UIButton!
    
    private var  signupViewModel:SignupViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupTogglePasswordButtons()
    }
    
    init(signupViewModel:SignupViewModel,nibName:String) {
        self.signupViewModel = signupViewModel
        super.init(nibName: nibName, bundle: nil)
    }
    
    convenience required init() {
        let defaultViewModel = SignupViewModel()
        self.init(signupViewModel:defaultViewModel , nibName: "\(SignupVC.self)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    // MARK: - Methods
    
    private func setupView() {
        topView.roundCorners(corners: [.bottomLeft,.bottomRight], radius: 40)
        containerView.roundCorners(corners: [.topLeft,.topRight], radius: 25)
        topView.applyShadow(color: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6), alpha: 0.2, x: 0, y: 4, blur: 50, spread: 0)
        nameTextField.keyboardType = .namePhonePad
        emailTextField.keyboardType = .emailAddress
        phoneNumberTextField.keyboardType = .phonePad
        
//        textFields.forEach {textfild in
//            textfild.setPadding(horizontal: 12)
//        }
        activityIndecator.hidesWhenStopped = true
        setPlaceholders()
        
    }
    
    private func setPlaceholders(){
        nameTextField.placeholder = "Write 14 character"
        emailTextField.placeholder = "Write your email"
        phoneNumberTextField.placeholder = "Write 11 numbers"
        passwordTextField.placeholder = "Write 8 character at least"
        confirmPasswordTextField.placeholder = "Write your password again"
    }
    
    private func setupTogglePasswordButtons(){
        // Configure the button
        togglePasswordButton.tintColor = .gray
        togglePasswordButton.setImage(UIImage(systemName:"eye")?.withRenderingMode(.alwaysTemplate), for: .normal) // Set the default eye icon
        togglePasswordButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)
        
        toggleConfirmPasswordButton.tintColor = .gray
        toggleConfirmPasswordButton.setImage(UIImage(systemName:"eye")?.withRenderingMode(.alwaysTemplate), for: .normal) // Set the default eye icon
        toggleConfirmPasswordButton.addTarget(self, action: #selector(toggleConfirmPasswordVisibility), for: .touchUpInside)
    }
    @objc private func togglePasswordVisibility() {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry

        // Change the button's icon based on the text visibility
        let imageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        togglePasswordButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)

        // To prevent the text field from losing the current typing cursor position
        if let existingText = passwordTextField.text {
            passwordTextField.text?.removeAll()
            passwordTextField.text = existingText
        }
        
        // Maintain the cursor position
        if let textRange = passwordTextField.selectedTextRange {
            passwordTextField.selectedTextRange = nil
            passwordTextField.selectedTextRange = textRange
        }
    }
    
    @objc private func toggleConfirmPasswordVisibility() {
        confirmPasswordTextField.isSecureTextEntry = !confirmPasswordTextField.isSecureTextEntry

        // Change the button's icon based on the text visibility
        let imageName = confirmPasswordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        toggleConfirmPasswordButton.setImage(UIImage(systemName: imageName)?.withRenderingMode(.alwaysTemplate), for: .normal)

        // To prevent the text field from losing the current typing cursor position
        if let existingText = confirmPasswordTextField.text {
            confirmPasswordTextField.text?.removeAll()
            confirmPasswordTextField.text = existingText
        }
        
        // Maintain the cursor position
        if let textRange = confirmPasswordTextField.selectedTextRange {
            confirmPasswordTextField.selectedTextRange = nil
            confirmPasswordTextField.selectedTextRange = textRange
        }
    }
    

    
    
}



