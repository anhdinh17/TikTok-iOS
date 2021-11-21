//
//  PostViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import UIKit

class PostViewController: UIViewController {

    var model: PostModel
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let commentButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "text.bubble.fill"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFit
        
        return button
    }()
    
    init(model: PostModel){
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let color: [UIColor] = [
            .red, .white, .orange, .systemPink, .darkGray, .systemGreen, .systemBlue
        ]
        
        view.backgroundColor = color.randomElement()
        
        setUpButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set size and frame for buttons
        let size: CGFloat = 40
        let yStart: CGFloat = view.height - (size*4)  - 30 - view.safeAreaInsets.bottom - (tabBarController?.tabBar.height ?? 0)
            // use enumerated
        for (index,button) in [likeButton,commentButton,shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10,
                                  y: yStart + (CGFloat(index)*10) + (CGFloat(index)*size),
                                  width: size,
                                  height: size)
        }
    }

    
    //MARK: - FUnctions
    func setUpButtons(){
        view.addSubview(likeButton)
        view.addSubview(commentButton)
        view.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
    }
    
    @objc func didTapLike(){
        model.isLikeByCurrentUser = !model.isLikeByCurrentUser
        
        likeButton.tintColor = model.isLikeByCurrentUser ? .systemRed : .white
    }
    
    @objc func didTapComment(){
        
    }
    
    @objc func didTapShare(){
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [],
                                          applicationActivities: [])
        
        present(vc,animated: true)
    }
}
