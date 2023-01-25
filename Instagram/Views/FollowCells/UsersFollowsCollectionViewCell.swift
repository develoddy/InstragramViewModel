//
//  FollowersCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import UIKit
import SDWebImage



class UsersFollowsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UsersFollowsCollectionViewCell"
    
    var viewModel: UsersFollowsCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        /**let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)*/
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        ///button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
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
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        profileImageView.sd_setImage(with: viewModel.userProfileImageURL)
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullName
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
    
    /*func configure(with model: UserRelationship) {
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
    }*/
}
