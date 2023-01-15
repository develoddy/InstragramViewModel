//
//  FollowersCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import UIKit

enum FollowState {
    case following // indicates the current user is following the other user
    case not_following // indicates the current user is NOT following the other user
}

struct UserRelationship {
    let username: String
    let namm: String
    let type: FollowState
}

class FollowersCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FollowersCollectionViewCell"
    
    private var model: UserRelationship?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "feed01")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "username"
        label.numberOfLines = 0
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 0
        label.text = "Eddy lujan"
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Follow", for: .normal)
        button.backgroundColor = .link
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(fullnameLabel)
        contentView.addSubview(followButton)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 10,
            paddingLeft: 10
        )
        let heightSize : CGFloat = 50
        profileImageView.setDimensions(height: heightSize, width: heightSize)
        profileImageView.layer.cornerRadius = heightSize / 2
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 1
        stack.alignment = .leading
        
        contentView.addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 6)
        
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width/3
        
        followButton.frame = CGRect(
            x: contentView.width-5-buttonWidth,
            y: (contentView.height-40)/2,
            width: buttonWidth,
            height: 40
        )
        
        //followButton.centerY(inView: usernameLabel, leftAnchor: usernameLabel.rightAnchor, paddingLeft: contentView.width-5-buttonWidth)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
        fullnameLabel.text = nil
    }
    
    func configure(with model: UserRelationship) {
        self.model = model
        usernameLabel.text = model.namm
        fullnameLabel.text = model.username
        
        switch model.type {
        case .following:
            followButton.setTitle("Unfollow", for: .normal)
            followButton.setTitleColor(.label, for: .normal)
            followButton.backgroundColor = .systemBackground
            followButton.layer.borderWidth = 1
            followButton.layer.borderColor = UIColor.label.cgColor
        case .not_following:
            followButton.setTitle("Follow", for: .normal)
            followButton.setTitleColor(.white, for: .normal)
            followButton.backgroundColor = .link
            followButton.layer.borderWidth = 0
            followButton.layer.borderColor = UIColor.label.cgColor
        }
    }
}
