//
//  ProfileHeaderCollectionReusableView.swift
//  TikTok
//
//  Created by Anh Dinh on 8/14/22.
//

import SDWebImage
import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapPrimaryButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowersButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapFollowingButtonWith viewModel: ProfileHeaderViewModel)
    func profileHeaderCollectionReusableView(_ header: ProfileHeaderCollectionReusableView,
                                             didTapAvatarFor viewModel: ProfileHeaderViewModel)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    lazy var avatarImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .systemPink
        return image
    }()
    
    lazy var primaryButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.backgroundColor = .secondarySystemBackground
        button.setTitle("Follow", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    lazy var followersButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.backgroundColor = .secondarySystemBackground
        button.setTitle("0\nFollowers", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    lazy var followingButton: UIButton = {
        let button = UIButton()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 6
        button.backgroundColor = .secondarySystemBackground
        button.setTitle("0\nFollowing", for: .normal)
        button.setTitleColor(UIColor.label, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 2
        return button
    }()
    
    var viewModel: ProfileHeaderViewModel?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        addSubviews()
        configureButtons()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let avatarSize: CGFloat = 130
        avatarImageView.frame = CGRect(x: (width - avatarSize)/2,
                                       y: 5,
                                       width: avatarSize,
                                       height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarImageView.width/2
        
        followersButton.frame = CGRect(x: (width - 210)/2,
                                       y: avatarImageView.bottom + 10,
                                       width: 100,
                                       height: 60)
        followingButton.frame = CGRect(x: followersButton.right + 10,
                                       y: avatarImageView.bottom + 10,
                                       width: 100,
                                       height: 60)
        primaryButton.frame = CGRect(x: (width - 220)/2,
                                     y: followingButton.bottom + 15,
                                     width: 220,
                                     height: 44)
    }
    
    //MARK: - Functions
    func addSubviews(){
        addSubview(avatarImageView)
        addSubview(followersButton)
        addSubview(followingButton)
        addSubview(primaryButton)
    }
    
    func configureButtons(){
        primaryButton.addTarget(self, action: #selector(didTapPrimaryButton), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowersButton), for: .touchUpInside)
        followingButton.addTarget(self, action: #selector(didTapFollowingButton), for: .touchUpInside)
    }
    
    @objc func didTapPrimaryButton(){
        guard let viewModel = self.viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapPrimaryButtonWith: viewModel)
    }
    
    @objc func didTapFollowersButton(){
        guard let viewModel = self.viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowersButtonWith: viewModel)
    }
    
    @objc func didTapFollowingButton(){
        guard let viewModel = self.viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapFollowingButtonWith: viewModel)
    }
    
    @objc func didTapAvatar(){
        guard let viewModel = self.viewModel else {return}
        delegate?.profileHeaderCollectionReusableView(self, didTapAvatarFor: viewModel)
    }
    
    func configure(with viewModel: ProfileHeaderViewModel){
        self.viewModel = viewModel
        // Setup our header
        followersButton.setTitle("\(viewModel.followerCount)\nFollowers", for: .normal)
        followingButton.setTitle("\(viewModel.followingCount)\nFollowing", for: .normal)
        if let avatarURL = viewModel.avatarImageURL {
            avatarImageView.sd_setImage(with: avatarURL, completed: nil)
        } else {
            avatarImageView.image = UIImage(named: "test")
        }
        
        if let isFollowing = viewModel.isFollowing {
            // if there's isFollowing from viewModel, that means we are looking at somebody's else profile
            // isFollwing is True means we are following this guy/her
            // then primary button is "Unfollow" and vice versa
            primaryButton.backgroundColor = isFollowing ? .secondarySystemBackground : .systemPink
            primaryButton.setTitle(isFollowing ? "Unfollow" : "Follow", for: .normal)
        } else {
            // this else means there's no isFollowing from viewModel,
            // that means this header is ourself, so primary button is "Edit Profile"
            primaryButton.backgroundColor = .secondarySystemBackground
            primaryButton.setTitle("Edit Profile", for: .normal)
        }
    }
}
