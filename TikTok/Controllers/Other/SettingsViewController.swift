//
//  SettingsViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class SettingsViewController: UIViewController {

    lazy var signOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("SIGN OUT", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        view.addSubview(signOutButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signOutButton.frame = CGRect(x: 30, y: 250, width: view.width - 60, height: 50)
    }

    @objc func didTapSignOut(){
        AuthManager.shared.signOut { [weak self] success in
            if success {
                let vc = SignInViewController()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
}
