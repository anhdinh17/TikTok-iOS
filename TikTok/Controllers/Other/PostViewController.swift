//
//  PostViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class PostViewController: UIViewController {

    let model: PostModel
    
    init(model: PostModel){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let color: [UIColor] = [
            .red, .white, .orange, .systemPink, .darkGray, .systemGreen, .systemBlue
        ]
        
        view.backgroundColor = color.randomElement()
    }

}
