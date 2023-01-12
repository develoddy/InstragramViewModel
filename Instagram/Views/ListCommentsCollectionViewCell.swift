//
//  ListCommentsCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit

class ListCommentsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ListCommentsCollectionViewCell"
    
    private let albumCoverImageView: UIImageView = {
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
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentTextLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //albumCoverImageView.frame = CGRect(x: 5, y: 2, width: contentView.height-4, height: contentView.height-4)
        albumCoverImageView.anchor(
            top: topAnchor,
            left: leftAnchor,
            paddingTop: 5,
            paddingLeft: 10
        )
        albumCoverImageView.setDimensions(height: 40, width: 40)
        albumCoverImageView.layer.cornerRadius = 40 / 2
        
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, commentTextLabel])
        stack.axis = .vertical
        stack.spacing = 1
        stack.alignment = .leading
        
        contentView.addSubview(stack)
        stack.centerY(inView: albumCoverImageView, leftAnchor: albumCoverImageView.rightAnchor, paddingLeft: 6)
        
        
        
        
        /*trackNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: 0,
            width: contentView.width-albumCoverImageView.right-15,
            height: contentView.height/2
        )
        
        artistsNameLabel.frame = CGRect(
            x: albumCoverImageView.right+10,
            y: contentView.height/2,
            width: contentView.width-albumCoverImageView.right-15,
            height: contentView.height/2
        )*/
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumCoverImageView.image = nil
        usernameLabel.text = nil
        commentTextLabel.text = nil
    }
    
    /*func configure(with viewModel: RecommendedTrackCellViewModel) {
        trackNameLabel.text = viewModel.name
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        artistsNameLabel.text = viewModel.artistName
    }*/
}
