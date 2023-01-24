//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 11/1/23.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier = "StoriesCollectionViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemPurple
        imageView.image = UIImage(named: "feed02")
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "Laura P."
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .systemGray,
        .systemTeal
    ]
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        profileImageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 12,
            paddingLeft: 12
        )
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 18)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helpers
    func configure() {
        
        //contentView.backgroundColor = colors.randomElement()
    }
    
    // MARK: - Actions
}
