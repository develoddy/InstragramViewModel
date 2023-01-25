//
//  NotificationsDefaultTableViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit

protocol NotificationsDefaultTableViewCellDelegate: AnyObject {
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsToFollow uid: String)
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsTounFollow uid: String)
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsToViewPost postId: String)
}


class NotificationsDefaultTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var viewModel: NotificationsDefaultTableViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: NotificationsDefaultTableViewCellDelegate?
    
    static let identifier = "NotificationsDefaultTableViewCell"
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        /**let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)*/
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private let subTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePostTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 0.5
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handleFollowTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(infoLabel)
        contentView.addSubview(profileImageView)
        contentView.addSubview(subTextLabel)
        contentView.addSubview(followButton)
        contentView.addSubview(postImageView)
        
        ///followButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 88, height: 32)
        
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        infoLabel.anchor(right: followButton.leftAnchor, paddingRight: 4)
    }
    
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        infoLabel.text = nil
        subTextLabel.text = nil
    }
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL, completed: nil)
        postImageView.sd_setImage(with: viewModel.postImageURL, completed: nil)
        infoLabel.attributedText = viewModel.notificationMessage
        
        followButton.isHidden = !viewModel.shouldHidePostImage
        postImageView.isHidden = viewModel.shouldHidePostImage
        
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        followButton.backgroundColor = viewModel.followButtonBackgroundColor
        followButton.setTitleColor(viewModel.followButtonTextColor, for: .normal)
    }
    
    // MARK: - Actions

    @objc func handleFollowTapped() {
        guard let viewModel = viewModel else { return }
        if viewModel.notification.userIsFollowed {
            delegate?.cell(self, wantsTounFollow: viewModel.notification.uid)
        } else {
            delegate?.cell(self, wantsToFollow: viewModel.notification.uid)
        }
    }
    
    @objc func handlePostTapped() {
        guard let postId = viewModel?.notification.postId else {
            return
        }
        delegate?.cell(self, wantsToViewPost: postId)
    }
}
