//
//  CommentsViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/22/21.
//

import UIKit

protocol CommentsViewControllerDelegate: AnyObject {
    func didTapCloseForComments(with viewController: CommentsViewController)
}

class CommentsViewController: UIViewController {

    weak var delegate: CommentsViewControllerDelegate?
    
    let post: PostModel
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        
        return button
    }()
  
//MARK: - Init
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
        
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        closeButton.frame = CGRect(x: view.width - 60,
                                   y: 10,
                                   width: 50,
                                   height: 50)
    }

//MARK: - Functions
    func fetchPostComments(){
        
    }
    
    @objc private func didTapClose(){
        delegate?.didTapCloseForComments(with: self)
    }
    
}
