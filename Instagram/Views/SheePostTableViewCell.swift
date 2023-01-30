//
//  SheePostTableViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 30/1/23.
//

import UIKit

struct SheePostTableViewCellViewModel {
    let iconImage: String
    let label: String
}

class SheePostTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SheePostTableViewCell"
    
    var viewModel: SheePostTableViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let iconUIImageView: UIImageView = {
        let iconUIImageView = UIImageView()
        iconUIImageView.tintColor = .black
        return iconUIImageView
    }()
    
    private let label: UILabel = {
        let textLabel = UILabel()
        textLabel.textColor = .label
        textLabel.numberOfLines = 1
        return textLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .secondarySystemBackground
        clipsToBounds = true
        contentView.addSubview(iconUIImageView)
        contentView.addSubview(label)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconUIImageView.frame = CGRect(
            x: 20,
            y: 10,
            width: contentView.height / 2,
            height: contentView.height / 2)
        iconUIImageView.layer.cornerRadius = iconUIImageView.height / 2
        
        label.frame = CGRect(
            x: iconUIImageView.right+15,
            y: 0,
            width: contentView.width-20-iconUIImageView.width,
            height: contentView.height )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.iconUIImageView.image = nil
        self.label.text = nil
    }
    
    
    //MARK: - Helpers

    public func configure() {
        guard let viewModel = self.viewModel else { return }
        updateUI(iconImage: viewModel.iconImage, label: viewModel.label)
    }
    
    func updateUI(iconImage: String, label: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold)
        self.iconUIImageView.image = UIImage(systemName: iconImage, withConfiguration: config)
        self.label.text = label
    }
    
    //MARK: - Actions
}
