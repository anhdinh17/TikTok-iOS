//
//  CommentsViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/22/21.
//

import UIKit

class CommentsViewController: UIViewController {

    let post: PostModel
    
    init(post: PostModel){
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
 
//MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        fetchPostComments()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

//MARK: - Functions
    func fetchPostComments(){
        
    }
    
}
