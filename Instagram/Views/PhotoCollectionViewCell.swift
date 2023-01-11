//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 10/1/23.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .white
        imageView.image = UIImage(
            systemName: "photo.on.rectangle.angled",
            withConfiguration:UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        //label.numberOfLines = 0
        return label
    }()
    
    private let colors: [UIColor] = [
        .systemPink,
        .systemBlue,
        .systemPurple,
        .systemOrange,
        .systemGreen,
        .systemRed,
        .systemYellow,
        .systemGray,
        .systemTeal
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 0
        contentView.layer.masksToBounds = true
        contentView.addSubview(imageView)
        contentView.addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-20, height: contentView.height/2)
        imageView.frame = CGRect(x: contentView.width/2, y: 10, width: contentView.width/20, height: contentView.height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = UIImage(
            systemName: "music.quarternote.3",
            withConfiguration:UIImage.SymbolConfiguration(pointSize: 50, weight: .regular))
    }
    
    //func configure(with viewModel: CategoryCollectionViewCellViewModel) {
    func configure() {
        label.text = ""
        //imageView.sd_setImage(with: viewModel.artworkURL, completed: nil)
        contentView.backgroundColor = colors.randomElement()
    }
}
