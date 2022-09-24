//
//  EditProfileViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 9/24/22.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close,
                                                           target: self,
                                                           action: #selector(didTapClose))
    }

    @objc func didTapClose(){
        dismiss(animated: true,completion: nil)
    }
    
}
