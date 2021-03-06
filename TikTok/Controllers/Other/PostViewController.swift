//
//  PostViewController.swift
//  TikTok
//
//  Created by Anh Dinh on 11/3/21.
//

import AVFoundation
import UIKit

protocol PostViewControllerDelegate: AnyObject {
    func postViewControllerDelegate(_ vc: PostViewController, didTapCommentButtonFor post: PostModel)
    func postViewControllerDelegate(_ vc: PostViewController, didTapProfileButtonFor post: PostModel)
}

class PostViewController: UIViewController {

    weak var delegate: PostViewControllerDelegate?
    
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
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named:"test"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.masksToBounds = true
        
        return button
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 24)
        label.text = "Check out this video #fyp #foryou #foryoupage"
        
        return label
    }()
    
    var player: AVPlayer?
    
    // This is for replaying the viedeo if users finish watching it
    private var playerDidFinishObserver: NSObjectProtocol?
    
    //MARK: - Init
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

        configureVideo()
        
        let color: [UIColor] = [
            .red, .orange, .systemPink, .darkGray, .systemGreen, .systemBlue
        ]
        
        view.backgroundColor = color.randomElement()
        
        setUpButtons()
        
        setUpDoubleTapToLike()
        
        view.addSubview(captionLabel)
        
        view.addSubview(profileButton)
        profileButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set size and frame for buttons
        let size: CGFloat = 40
        let yStart: CGFloat = view.height - (size*4)  - 30 - view.safeAreaInsets.bottom
            // use enumerated
        for (index,button) in [likeButton,commentButton,shareButton].enumerated() {
            button.frame = CGRect(x: view.width - size - 10,
                                  y: yStart + (CGFloat(index)*10) + (CGFloat(index)*size),
                                  width: size,
                                  height: size)
        }
        
        // Set up frame for profile button
        profileButton.frame = CGRect(x: likeButton.left,
                                     y: likeButton.top - 10 - size,
                                     width: size,
                                     height: size)
        profileButton.layer.cornerRadius = size/2
        
        // set up frame for captionLabel, this is dynamic frame to fit the label if the label has a long String
        captionLabel.sizeToFit()
        let labelSize = captionLabel.sizeThatFits(CGSize(width: view.width - size - 12,
                                         height: view.height))
        captionLabel.frame = CGRect(x: 5,
                                    y: view.height - 10 - view.safeAreaInsets.bottom - labelSize.height,
                                    width: view.width - size - 12,
                                    height: labelSize.height)
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
        delegate?.postViewControllerDelegate(self, didTapCommentButtonFor: model)
    }
    
    @objc func didTapShare(){
        guard let url = URL(string: "https://www.tiktok.com") else {
            return
        }
        
        let vc = UIActivityViewController(activityItems: [url],
                                          applicationActivities: [])
        
        present(vc,animated: true)
    }
    
    @objc func didTapProfileButton(){
        delegate?.postViewControllerDelegate(self, didTapProfileButtonFor: model)
    }
    
    // Func to play video
    private func configureVideo(){
        guard let path = Bundle.main.path(forResource: "harrypotter", ofType: "mp4") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        player = AVPlayer(url: url)
        
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player?.volume = 0
        player?.play()
        
        // Replay the video if users have watched til the end
        guard let player = player else {
            return
        }
        playerDidFinishObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player.currentItem,
            queue: .main,
            using: { _ in
                player.seek(to: .zero)
                player.play()
            })
    }
    
    /*
    Below is how to double tap on the screen
    Animation to fade the heart
    **/
    func setUpDoubleTapToLike(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(_ :)))
        tap.numberOfTapsRequired = 2
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
    }
    
    @objc func didDoubleTap(_ gesture: UITapGestureRecognizer){
        if !model.isLikeByCurrentUser {
            model.isLikeByCurrentUser = true
        }
        
        // double tap on wherever on the screen.
        let touchPoint = gesture.location(in: view)
        
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.center = touchPoint
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0
        view.addSubview(imageView)
        
        /*
        When users double tap, it executes didDoubTap().
        Animation explained: after double tap, in 0.2 sec, the heart will show up in red. And after the next 0.2 sec (because of DispatchQueue), another animation which lasts 0.3 sec kick in to fade the heart and to remove it from superView
        */
        UIView.animate(withDuration: 0.2) {
            imageView.alpha = 1
        } completion: { done in
            if done {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 0
                    } completion: { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        }

        
    }
}
