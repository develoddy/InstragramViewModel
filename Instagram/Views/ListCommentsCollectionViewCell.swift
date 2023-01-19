//
//  ListCommentsCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit

class ListCommentsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ListCommentsCollectionViewCell"
    
    private let postImageView: UIImageView = {
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
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 0
        label.text = "Esto es un comentario para una prueba en la aplicación y se pueda ver bien con un salto de linea."
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(postImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentTextLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        postImageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 5,
            paddingLeft: 10
        )
        postImageView.setDimensions(height: 40, width: 40)
        postImageView.layer.cornerRadius = 40 / 2
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, commentTextLabel])
        stack.axis = .vertical
        stack.spacing = 1
        stack.alignment = .leading
        
        contentView.addSubview(stack)
        stack.centerY(inView: postImageView, leftAnchor: postImageView.rightAnchor, paddingLeft: 6)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        usernameLabel.text = nil
        commentTextLabel.text = nil
    }
    
    /*func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        artistsNameLabel.text = viewModel.artistName
    }*/
}
