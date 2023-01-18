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
    
    private let postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "feed01")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /*private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = "Name Label"
        return label
    }()*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        
        addSubview(postImageView)
        //addSubview(nameLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*postImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        postImageView.setDimensions(height: 80, width: 80)
        postImageView.layer.cornerRadius = 80 / 2
        
        nameLabel.anchor(top: postImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)*/
        postImageView.fillSuperView()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: FeedCollectionViewCellViewModel) {
        updateUI(imageURL: viewModel.imageURL)
    }
    
    func updateUI(imageURL: URL?) {
        postImageView.sd_setImage(with: imageURL)
    }
}
