//
//  NotificationsDefaultTableViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit




class NotificationsDefaultTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    var viewModel: NotificationsDefaultTableViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    static let identifier = "NotificationsDefaultTableViewCell"
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        ///imageView.image = UIImage(named: "person.circle")
        return imageView
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 1
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleFollowTapped))
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
        //contentView.clipsToBounds = true
        //accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // let imageSize: CGFloat = contentView.height-10
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        /*let stack = UIStackView(arrangedSubviews: [label, subTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .leading
        contentView.addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)*/
        
        infoLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        

        addSubview(followButton)
        followButton.centerY(inView: self)
        followButton.anchor(right: rightAnchor, paddingRight: 12, width: 100, height: 32)
        
        addSubview(postImageView)
        postImageView.centerY(inView: self)
        postImageView.anchor(right: rightAnchor, paddingRight: 12, width: 40, height: 40)
        
        followButton.isHidden = true
    }
    
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        infoLabel.text = nil
        subTextLabel.text = nil
    }
    
    //func configure(with viewModel: NotificationsDefaultTableViewCellViewModel) {
    func configure() {
        guard let viewModel = self.viewModel else { return }
        
        profileImageView.sd_setImage(with: viewModel.profileImageURL, completed: nil)
        postImageView.sd_setImage(with: viewModel.postImageURL, completed: nil)
        infoLabel.attributedText = viewModel.notificationMessage
        
        
        ///label.text = "user"
        ///subTextLabel.text = "3 h"
        //profileImageView.image = UIImage(systemName: "person.circle")
        
    }
    
    
    // MARK: - Actions
    @objc func handleFollowTapped() {
        
    }
}
