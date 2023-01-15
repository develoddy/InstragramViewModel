//
//  ProfileHeaderCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/1/23.
//

import UIKit
import SDWebImage

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func ProfileHeaderCollectionReusableViewDidTapPosts(_ posts: String)
    func ProfileHeaderCollectionReusableViewDidTapFollowers(_ followers: String)
    func ProfileHeaderCollectionReusableViewDidTapFollowings(_ followings: String)
    func ProfileHeaderCollectionReusableViewDidTapEditProfile(_ editProfile: String)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .bold)
        //label.text = "Laura P."
        return label
    }()
    
    private lazy var editProfilefollowButton : UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        return button
    }()
    
    lazy private var postsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        return button
    }()
    
    lazy private var followersButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        return button
    }()
    
    lazy private var followingsButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .thin)
        return button
    }()
  
    private let gridButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.grid.3x3"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let listButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "tag"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    private let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(editProfilefollowButton)
        
        attributedStartText(value: 3, button: followersButton, label: "Followers")
        attributedStartText(value: 10, button: followingsButton, label: "Followings")
        attributedStartText(value: 5, button: postsButton, label: "Posts")
        
        postsButton.addTarget(self, action: #selector(didTapPosts), for: .touchUpInside)
        followersButton.addTarget(self, action: #selector(didTapFollowers), for: .touchUpInside)
        followingsButton.addTarget(self, action: #selector(didTapFollowings), for: .touchUpInside)
        editProfilefollowButton.addTarget(self, action: #selector(didTapEditProfile), for: .touchUpInside)
    }
    
    
    // MARK: - Init
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 12)
        profileImageView.setDimensions(height: 80, width: 80)
        profileImageView.layer.cornerRadius = 80/2.0
        
        nameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 12)
        
        editProfilefollowButton.anchor(top: nameLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24)
        
        let stack = UIStackView(arrangedSubviews: [postsButton, followersButton, followingsButton])
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor(left: profileImageView.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 12, height: 50)
        
        let topDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let bottomDivider = UIView()
        topDivider.backgroundColor = .lightGray
        
        let buttonStack = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        buttonStack.distribution = .fillEqually
        
        addSubview(buttonStack)
        addSubview(topDivider)
        addSubview(bottomDivider)
        
        buttonStack.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)
        
        topDivider.anchor(top: buttonStack.topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        bottomDivider.anchor(top: buttonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

    // MARK: - Helpers

    private func attributedStartText(value: Int, button: UIButton, label: String) {
        button.titleLabel?.lineBreakMode = NSLineBreakMode.byCharWrapping
        let buttonText: NSString = "\(value) \n \(label)" as NSString
        let newlineRange: NSRange = buttonText.range(of: "\n")
        
        var substring1 = ""
        var substring2 = ""
        
        if(newlineRange.location != NSNotFound) {
            substring1 = buttonText.substring(to: newlineRange.location)
            substring2 = buttonText.substring(from: newlineRange.location)
        }
        
        let font1: UIFont = .systemFont(ofSize: 14, weight: .semibold)
        let attributes1 = [NSMutableAttributedString.Key.font: font1]
        let attrString1 = NSMutableAttributedString(string: substring1, attributes: attributes1)
        
        let font2: UIFont = .systemFont(ofSize: 14, weight: .thin)
        let attributes2 = [NSMutableAttributedString.Key.font: font2]
        let attrString2 = NSMutableAttributedString(string: substring2, attributes: attributes2)
        
        attrString1.append(attrString2)
        button.setAttributedTitle(attrString1, for: [])
    }
    
    //func configure(with viewModel: User ) {
    func configure(with viewModel: ProfileHeaderViewModel) {
        nameLabel.text = viewModel.user.username
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
    }
    
    // MARK: - Actions
    
    @objc func didTapPosts() {
        delegate?.ProfileHeaderCollectionReusableViewDidTapPosts("Posts")
    }
    
    @objc func didTapFollowers() {
        delegate?.ProfileHeaderCollectionReusableViewDidTapFollowers("followers")
    }
    
    @objc func didTapFollowings() {
        delegate?.ProfileHeaderCollectionReusableViewDidTapFollowings("Followings")
    }
    
    @objc func didTapEditProfile() {
        delegate?.ProfileHeaderCollectionReusableViewDidTapEditProfile("Edit Profile")
    }
}
