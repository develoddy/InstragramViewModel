//
//  CreateStoryCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//

import UIKit

class CreateStoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CreateStoryCollectionViewCell"
    
    var viewModel: StoryCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let createStoryImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .black
        label.text = "Tu historia"
        return label
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(createStoryImageView)
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        createStoryImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 16) // 12
        createStoryImageView.setDimensions(height: 50, width: 50)
        createStoryImageView.layer.cornerRadius = 50/2.0
        createStoryImageView.backgroundColor = .secondarySystemBackground
        
        nameLabel.anchor(top: createStoryImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 6)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper
    
    func configure() {
      
    }
    
    // MARK: - Actions
}
