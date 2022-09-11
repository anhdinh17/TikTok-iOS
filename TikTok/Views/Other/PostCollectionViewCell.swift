//
//  PostCollectionViewCell.swift
//  TikTok
//
//  Created by Anh Dinh on 9/11/22.
//

import AVFoundation
import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    
    lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        contentView.addSubview(imageView)
        contentView.backgroundColor = .secondarySystemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    //MARK: - Functions
    func configure(with post: PostModel){
        StorageManager.shared.getDownloadURL(for: post) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let url):
                    // generate thumbnail
                    // use the url of video post, and make a thumbnail image out of it.
                    // AVFoundation takes the first frame of the video and convert it to image.
                    let asset = AVAsset(url: url)
                    let generator = AVAssetImageGenerator(asset: asset)
                    do {
                        let cgImage = try generator.copyCGImage(at: .zero, actualTime: nil)
                        // set imageView to be cgImage
                        self?.imageView.image = UIImage(cgImage: cgImage)
                    }catch{
                        
                    }
                case .failure(let error):
                    print("FAILED TO GET DOWNLOAD URL: \(error)")
                }
            }
        }
    }
}
