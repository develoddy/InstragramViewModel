//
//  ListCommentsCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit
import SDWebImage

class ListCommentsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ListCommentsCollectionViewCell"
    
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
    
    /*private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 0
        label.text = "Esto es un comentario para una prueba en la aplicación y se pueda ver bien con un salto de linea."
        return label
    }()*/
    
    private let commentLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(profileImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /*profileImageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 5,
            paddingLeft: 10
        )
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, commentTextLabel])
        stack.axis = .vertical
        stack.spacing = 1
        stack.alignment = .leading
        
        contentView.addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: postImageView.rightAnchor, paddingLeft: 6)*/
         
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 8)
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        commentLabel.numberOfLines = 0
        commentLabel.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 8)
        commentLabel.anchor(right: rightAnchor, paddingRight: 8)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        usernameLabel.text = nil
        commentLabel.text = nil
    }
    
    /*func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        artistsNameLabel.text = viewModel.artistName
    }*/
    
    func configure(with viewModel: ListCommentsCollectionViewCellViewModel) {
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        //usernameLabel.text = viewModel.username
        commentLabel.attributedText = viewModel.commentLabelText()
    }
}
