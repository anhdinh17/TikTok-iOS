//
//  NotificationsUserFollowTableViewCell.swift
//  TikTok
//
//  Created by Anh Dinh on 6/24/22.
//

import UIKit

protocol NotificationsUserFollowTableViewCellDelegate: AnyObject {
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell,
                                              didTapFollowFor username: String)
    func notificationsUserFollowTableViewCell(_ cell: NotificationsUserFollowTableViewCell,
                                              didTapAvatarFor username: String)
}

class NotificationsUserFollowTableViewCell: UITableViewCell {
    static let identifier = "NotificationsUserFollowTableViewCell"

    weak var delegate: NotificationsUserFollowTableViewCellDelegate?
    
    private let avatarImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        return button
    }()
    
    var username: String?
    
//MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(avatarImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        contentView.addSubview(dateLabel)
        selectionStyle = .none
        followButton.addTarget(self, action: #selector(didTapFollow), for: .touchUpInside)
        // add tap to avatar
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let iconSize: CGFloat = 50
        avatarImageView.frame = CGRect(x: 10,
                                       y: 3 ,
                                       width: iconSize,
                                       height: iconSize)
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.layer.masksToBounds = true
        
        followButton.sizeToFit()
        followButton.frame = CGRect(x: contentView.width - 100 - 10,
                                    y: 10,
                                    width: 100,
                                    height: 30)
        
        label.sizeToFit()
        dateLabel.sizeToFit()
        let labelSize = label.sizeThatFits(CGSize(
            width: contentView.width - 30 - followButton.width - iconSize,
            height: contentView.height - 40))
        label.frame = CGRect(x: avatarImageView.right + 10,
                             y: 0,
                             width: labelSize.width,
                             height: labelSize.height)
        dateLabel.frame = CGRect(x: avatarImageView.right + 10,
                                 y: label.bottom + 3,
                                 width: contentView.width - followButton.width - avatarImageView.width,
                                 height: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
        label.text = nil
        dateLabel.text = nil
        
        // Reset the cell for next use
        followButton.setTitle("Follow", for: .normal)
        followButton.backgroundColor = .systemBlue
        followButton.layer.borderWidth = 0
        followButton.layer.borderColor = nil
    }
 
//MARK: - Functions
    
    @objc func didTapFollow(){
        guard let username = username else {return}
        
        // When users tap Follow button
        followButton.setTitle("Following", for: .normal)
        followButton.backgroundColor = .clear
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.lightGray.cgColor
        
        delegate?.notificationsUserFollowTableViewCell(self,
                                                       didTapFollowFor: username)
    }
    
    @objc func didTapAvatar(){
        guard let username = username else {return}
        delegate?.notificationsUserFollowTableViewCell(self,
                                                       didTapAvatarFor: username)
    }
    
    func configure(with username: String, model: Notification){
        self.username = username
        avatarImageView.image = UIImage(named: "test")
        label.text = model.text
        dateLabel.text = .date(with: model.date)
    }
    
}
