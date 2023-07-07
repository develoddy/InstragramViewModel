//
//  SearchResultDefaultTableViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 10/1/23.
//

import UIKit

struct SearchResultDefaultTableViewCellViewModel {
    let username: String
    let fullname: String
    let imageURL: URL?
}

class SearchResultDefaultTableViewCell: UITableViewCell {
    
    static let identifier = "SearchResultDefaultTableViewCell"
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = .lightGray
        return label
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        //contentView.addSubview(usernameLabel)
        //contentView.addSubview(fullnameLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        
        iconImageView.setDimensions(height: imageSize, width: imageSize)
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
        iconImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, fullnameLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        
        contentView.addSubview(stack)
        stack.centerY(inView: iconImageView, leftAnchor: iconImageView.rightAnchor, paddingLeft: 6)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        usernameLabel.text = nil
        fullnameLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultDefaultTableViewCellViewModel) {
    //func configure(with viewModel: ) {
        usernameLabel.text = viewModel.username
        fullnameLabel.text = viewModel.fullname
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
        //iconImageView.image = UIImage(systemName: "person.circle")
    }
    
}
