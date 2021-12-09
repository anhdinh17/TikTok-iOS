//
//  ExplorePostCollectionViewCell.swift
//  TikTok
//
//  Created by Anh Dinh on 12/8/21.
//

import UIKit

class ExplorePostCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorePostCollectionViewCell"
    
    private let thumbNailImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        
        return image
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        
        contentView.addSubview(captionLabel)
        contentView.addSubview(thumbNailImageView)
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbNailImageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.height - 80)
        captionLabel.frame = CGRect(x: 0, y: contentView.height - 80, width: contentView.width, height: 80)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbNailImageView.image = nil
        captionLabel.text = nil
    }
    
    func configure(with viewModel: ExplorePostViewModel){
        thumbNailImageView.image = viewModel.thumbnailImage
        captionLabel.text = viewModel.caption
    }
}
