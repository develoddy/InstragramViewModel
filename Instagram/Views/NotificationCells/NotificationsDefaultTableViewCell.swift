//
//  NotificationsDefaultTableViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit

struct NotificationsDefaultTableViewCellViewModel {
    let username: String
    let imageURL: URL?
}


class NotificationsDefaultTableViewCell: UITableViewCell {

    // MARK: - Properties
    
    static let identifier = "NotificationsDefaultTableViewCell"
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "person.circle")
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .semibold)
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
    
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconImageView)
        contentView.addSubview(subTextLabel)
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
        
        let stack = UIStackView(arrangedSubviews: [label, subTextLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.alignment = .leading
        
        contentView.addSubview(stack)
        stack.centerY(inView: iconImageView, leftAnchor: iconImageView.rightAnchor, paddingLeft: 6)
    }
    
    
    // MARK: - Helpers
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subTextLabel.text = nil
    }
    
    func configure(with viewModel: NotificationsDefaultTableViewCellViewModel) {
        label.text = viewModel.username
        subTextLabel.text = "3 h"
        iconImageView.sd_setImage(with: viewModel.imageURL, completed: nil)
    }
    
    
    // MARK: - Actions
}
