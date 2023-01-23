//
//  PostsCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit
import SDWebImage

protocol FeedCollectionViewCellDelegate: AnyObject {
    func feedCollectionDidTapLike(_ cell: FeedCollectionViewCell, didLike post: Post)
    func feedCollectionDidTapComment(_ cell: FeedCollectionViewCell, wantsShowCommentFor post: Post)
    func feedCollectionDidTapShare(_ user: String)
    func feedCollectionDidTapMoreComments(_ user: String)
}

class FeedCollectionViewCell: UICollectionViewCell {
    
    
    var viewModel: FeedCollectionViewCellViewModel?
    
    static let identifier = "FeedCollectionViewCell"
    
    weak var delegate: FeedCollectionViewCellDelegate?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("User", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        button.addTarget(self, action: #selector(didTapUsername), for: .touchUpInside)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .systemPurple
        return imageView
    }()
    
    lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        //button.setImage(UIImage(systemName: "heart"), for: .normal)
        //button.tintColor = .black
        return button
    }()
    
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "message"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var sharedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Some test caption for now.."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let moreCommentsLabel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ver más comentarios", for: .normal)
        button.setTitleColor(UIColor.lightGray, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    private let postTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2 days ago"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemYellow
        
        addSubview(profileImageView)
        addSubview(usernameButton)
        
        addSubview(postImageView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(sharedButton)
        
        addSubview(likesLabel)
        addSubview(captionLabel)
        addSubview(moreCommentsLabel)
        addSubview(postTimeLabel)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        sharedButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        moreCommentsLabel.addTarget(self, action: #selector(didTapMoreComments), for: .touchUpInside)
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
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        usernameButton.centerY(
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 8
        )
        
        postImageView.anchor(
            top: profileImageView.bottomAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 8
        )
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        configureActionButtons()
        
        likesLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, paddingTop: -4, paddingLeft: 8)
        
        captionLabel.anchor(top: likesLabel.bottomAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        moreCommentsLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
        
        postTimeLabel.anchor(top: moreCommentsLabel.bottomAnchor, left: leftAnchor, paddingTop: 4, paddingLeft: 8)
    }
    

    override func prepareForReuse() {
        super.prepareForReuse()
        captionLabel.text = nil
        postImageView.image = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    
    // MARK: - Helpers
    func configureActionButtons() {
        stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sharedButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        stackView.anchor(top: postImageView.bottomAnchor, width: 120, height: 50)
    }
    
    
    func configure(with viewModel: FeedCollectionViewCellViewModel) {
        self.viewModel = viewModel
    
        //print("DEBUG: CELL Post caption is \(viewModel.post.caption) & Post didLike is \(viewModel.post.didLike)")
        
        guard let likeButtonImage = viewModel.likeButtonImage else {return}
        updateUI(
            caption: viewModel.caption,
            imageURL: viewModel.imageURL,
            likes: viewModel.likesLabelText,
            userProfileImageURL: viewModel.userProfileImageURL,
            username: viewModel.username,
            likeButtonTintColor: viewModel.likeButtonTintColor,
            likeButtonImage: likeButtonImage
        )
    }
    
    private func updateUI(
        caption: String,
        imageURL: URL?,
        likes: String,
        userProfileImageURL: URL?,
        username: String,
        likeButtonTintColor: UIColor,
        likeButtonImage: UIImage
    ) {
        captionLabel.text = caption
        postImageView.sd_setImage(with: imageURL)
        likesLabel.text = likes
        profileImageView.sd_setImage(with: userProfileImageURL)
        usernameButton.setTitle(username, for: .normal)
        likeButton.tintColor = likeButtonTintColor
        likeButton.setImage(likeButtonImage, for: .normal)
    }
    
    // MARK: - Actions
    @objc func didTapUsername() {
        //
    }
    
    @objc func didTapLike() {
        guard let viewModel = self.viewModel else { return }
        delegate?.feedCollectionDidTapLike(self, didLike: viewModel.post)
    }
    
    @objc func didTapComment() {
        guard let viewModel = self.viewModel else { return }
        delegate?.feedCollectionDidTapComment(self, wantsShowCommentFor: viewModel.post)
    }
    
    @objc func didTapShare() {
        delegate?.feedCollectionDidTapShare("user")
    }
    
    @objc func didTapMoreComments() {
        print("debug: comment")
        delegate?.feedCollectionDidTapMoreComments("user")
    }
}
