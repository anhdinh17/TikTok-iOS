//
//  SignUpViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit
import SafariServices

class SignUpViewController: UIViewController, UITextFieldDelegate {
    var completion: (()->Void)?
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    private let usernameField = AuthField(type: .username)
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    private let termsButton = AuthButton(type: .plain, title: "Terms of Service")
    private let signUpButton = AuthButton(type: .signUp, title: nil)
    
    //=======================================================================================================
    //MARK: Lifecycle
    //=======================================================================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Sign Up"
        addSubviews()
        configureButton()
        configureFields()
    }

    // When page appears, keyboard of username field automatically shows up.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageSize: CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width-imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        usernameField.frame = CGRect(x: 20, y: logoImageView.bottom + 10, width: view.width - 40, height: 55)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom + 5, width: view.width - 40, height: 55)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 5, width: view.width - 40, height: 55)
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom + 25, width: view.width-40, height: 55)
        termsButton.frame = CGRect(x: 20, y: signUpButton.bottom + 20, width: view.width-40, height: 55)
    }
    
    //=======================================================================================================
    //MARK: Functions
    //=======================================================================================================
    func addSubviews(){
        view.addSubview(usernameField)
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
    }
    
    func configureFields(){
        usernameField.delegate = self
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
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
    }
    
    //=======================================================================================================
    //MARK: Actions
    //=======================================================================================================
    @objc func didTapSignUp(){
        didTapKeyboardDone()
        guard let username = usernameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6,
              !username.contains(" "),
              !username.contains(".") else {
            let alert = UIAlertController(title: "Invalid Input", message: "Please make sure to use valid username, email, password to create your account.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        AuthManager.shared.signUp(with: username, emailAddress: email, password: password) { success in
            if success {
                
            }else {
                
            }
        }
    }
    
    @objc func didTapTerms(){
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/legal/terms-of-service?lang=en") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    @objc func didTapKeyboardDone(){
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
}
