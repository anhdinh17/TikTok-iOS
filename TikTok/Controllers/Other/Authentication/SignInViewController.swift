//
//  SignInViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit
import SafariServices

class SignInViewController: UIViewController, UITextFieldDelegate {
    var completion: (()->Void)?
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    private let signInButton = AuthButton(type: .signIn, title: nil)
    private let forgotPassword = AuthButton(type: .plain, title: "Forgot Password")
    private let signUpButton = AuthButton(type: .plain, title: "New User? Create Account")
    
    //=======================================================================================================
    //MARK: Lifecycle
    //=======================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign in"
        addSubviews()
        configureButton()
        configureFields()
        //DatabaseManager.shared.createRootUser()
    }

    // When page appears, keyboard of email field automatically shows up.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width-imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        emailField.frame = CGRect(x: 20, y: logoImageView.bottom + 10, width: view.width - 40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 5, width: view.width - 40, height: 55)
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom + 25, width: view.width-40, height: 55)
        forgotPassword.frame = CGRect(x: 20, y: signInButton.bottom + 20, width: view.width-40, height: 55)
        signUpButton.frame = CGRect(x: 20, y: forgotPassword.bottom + 20, width: view.width-40, height: 55)
    }
    
    func addSubviews(){
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(signUpButton)
        view.addSubview(forgotPassword)
    }
    
    func configureFields(){
        emailField.delegate = self
        passwordField.delegate = self
        // Add a toolbar on top of keyboard
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolbar.items = [
            // Add space between items on toolbar, if we only have 1 item, then it's pushed all the way to the right.
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        // Add tool bar to textFields
        emailField.inputAccessoryView = toolbar
        passwordField.inputAccessoryView = toolbar
        
    }
    
    func configureButton(){
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        forgotPassword.addTarget(self, action: #selector(didTapForgotPassword), for: .touchUpInside)
    }
    
    //=======================================================================================================
    //MARK: Actions
    //=======================================================================================================
    @objc func didTapSignIn(){
        didTapKeyboardDone()
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
            // alert for wrong email/password
            let alert = UIAlertController(title: "Invalid Email/Password", message: "Please enter valid email and password to sign in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert,animated: true)
            return
        }
        AuthManager.shared.signIn(with: email, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case.success:
                    HapticsManager.shared.vibrate(for: .success)
                    self?.dismiss(animated: true, completion: nil)
                case .failure(let error):
                    HapticsManager.shared.vibrate(for: .error)
                    let alert = UIAlertController(title: "Sign In Failed", message: "Please enter valid email and password to sign in", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert,animated: true)
                    self?.passwordField.text = nil // empty password field after sign in
                }
            }
        }
    }
    
    @objc func didTapSignUp(){
        didTapKeyboardDone()
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapForgotPassword(){
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    @objc func didTapKeyboardDone(){
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
