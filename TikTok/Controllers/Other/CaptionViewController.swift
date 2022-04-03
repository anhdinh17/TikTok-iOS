//
//  CaptionViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 4/2/22.
//

import UIKit

class CaptionViewController: UIViewController {
    
    let videoURL: URL
    
    init(videoURL:URL){
        self.videoURL = videoURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Add Caption"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done
                                                            , target: self, action: #selector(didTapPost))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    //=======================================================================================================
    //MARK: Functions
    //=======================================================================================================
    @objc func didTapPost(){
        
    }
}
