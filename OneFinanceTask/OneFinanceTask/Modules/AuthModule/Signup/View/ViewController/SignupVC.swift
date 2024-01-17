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
        setupbinding()
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
    
    private func setupbinding(){
        
        signupButton.rx.tap
            .throttle(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(Observable.combineLatest(emailTextField.rx.text.orEmpty, passwordTextField.rx.text.orEmpty,phoneNumberTextField.rx.text.orEmpty,nameTextField.rx.text.orEmpty))
            .subscribe(onNext: { [weak self] email, password, phone, name in
                let deviceToken = "12233454566787877"
                self?.signupViewModel.register(name: name, email: email, phone: phone, password: password, deviceToken: deviceToken)
            })
            .disposed(by: disposeBag)
        
        
        signupViewModel.isLoading.subscribe {[weak self] in
            guard let self else {return}
            $0 ? self.activityIndecator.startAnimating() : self.activityIndecator.stopAnimating()
        }
        .disposed(by: disposeBag)
        
        
        signupViewModel.registerResult
            .subscribe(onNext: { [weak self] registerModel in
                guard let self , let userData = registerModel.data else {return}
                print("Login successful: \(registerModel)")
                if registerModel.success ?? false && registerModel.responseCode ?? 0 == 200 {
                    UserDefaults.standard.setObject(true, forKey: .userLoggedin)
                    UserDefaults.standard.setCodableObject(userData, forKey: .saveUserData)
                    self.signupViewModel.didUserRegistered(userData: userData)
                }else {
                    showMessage(typeMessage: .error, message: registerModel.message ?? "")
                }
            }, onError: { error in
                // Handle login error, show error message, etc.
                print("Login error: \(error)")
            })
            .disposed(by: disposeBag)
        
        
        let nameValid = nameTextField.rx.text.orEmpty
            .map { self.isValidName($0) }
            .share(replay: 1)
        let emailValid = emailTextField.rx.text.orEmpty
            .map { self.isValidEmail($0) }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map { self.isValidPassword($0) }
            .share(replay: 1)
        
        let confirmPasswordValid = Observable.combineLatest(passwordTextField.rx.text.orEmpty, confirmPasswordTextField.rx.text.orEmpty)
            .map { self.arePasswordsEqual($0, $1) }
            .share(replay: 1)
        
        let phoneValid = phoneNumberTextField.rx.text.orEmpty
            .map { self.isValidPhone($0) }
            .share(replay: 1)
        
        Observable.combineLatest(nameValid,emailValid, passwordValid, confirmPasswordValid, phoneValid) { $0 && $1 && $2 && $3 && $4 }
            .bind(to: signupButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        // Restrict typing in nameTextField when count reaches 14 characters
        nameTextField.rx.text.orEmpty
                    .map { [weak self] text -> String in
                        if text.count > 14 {
                            self?.showMessage(typeMessage: .error, message: "Name cannot exceed 14 characters")
                        }
                        return String(text.prefix(14))
                    }
                    .bind(to: nameTextField.rx.text)
                    .disposed(by: disposeBag)
        
        // Restrict typing in phoneTextField when count reaches 11 characters
        phoneNumberTextField.rx.text.orEmpty
                   .map { [weak self] text -> String in
                       
                       if text.count > 11 {
                           self?.showMessage(typeMessage: .error, message: "Phone number cannot exceed 11 characters")
                       }
                       return String(text.prefix(11))
                   }
                   .bind(to: phoneNumberTextField.rx.text)
                   .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .subscribe(onNext: {[weak self] in
                guard let self else {return}
                self.signupViewModel.didTappedLogin()
            }).disposed(by: disposeBag)
    }
    
    
}



