//
//  PhotosCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/1/23.
//

import UIKit
import SDWebImage

struct ProfilePhotosCollectionViewCellViewModel {
    
}

class ProfilePhotosCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotosCollectionViewCell"
    
    var viewModel: FeedCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "feed01")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.fillSuperView()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        updateUI(imageURL: viewModel.imageURL)
    }
    
    func updateUI(imageURL: URL?) {
        postImageView.sd_setImage(with: imageURL)
    }
}
