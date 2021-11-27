//
//  ProfileViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class ProfileViewController: UIViewController {

    let user: User
    
    init(user: User){
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = user.userName
        view.backgroundColor = .systemBackground
    }

}
