//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "StoryCollectionViewCell"
    
    var viewModel: StoryCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let imageURL: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageURL)
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageURL.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 10) // 12
        imageURL.setDimensions(height: 60, width: 60)
        imageURL.layer.cornerRadius = 60/2.0
        imageURL.backgroundColor = .secondarySystemBackground
        
        nameLabel.anchor(top: imageURL.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 20)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper
    
    func configure() {
        guard let viewModel = self.viewModel else {
            return
        }
        nameLabel.text = viewModel.username
        imageURL.sd_setImage(with: viewModel.imageURL)
    }
    
    // MARK: - Actions
}
