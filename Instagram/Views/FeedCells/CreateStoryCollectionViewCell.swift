//
//  CreateStoryCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//

import UIKit
import SDWebImage


protocol CreateStoryCollectionViewCellDelegate: AnyObject {
    func cell(_ createStoryCell: CreateStoryCollectionViewCell, didTapActionButtonFor user: User)
}

class CreateStoryCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "CreateStoryCollectionViewCell"
    
    weak var delegate: CreateStoryCollectionViewCellDelegate?
    
    var viewModel: CreateStoryCollectionViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var createStoryImageView: UIButton = {
        let button = UIButton()
        button.backgroundColor = .lightGray
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(didTapUploadHistory), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusImageView: UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.layer.borderWidth = 4
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = .systemBlue
        let config = UIImage.SymbolConfiguration(pointSize: 10, weight: .heavy)
        let image = UIImage(systemName: "plus", withConfiguration: config)?.withRenderingMode(.alwaysOriginal).withTintColor(.white)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(didTapUploadHistory), for: .touchUpInside)
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10, weight: .bold)
        label.textColor = .lightGray
        label.text = "Crear historia"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(createStoryImageView)
        addSubview(plusImageView)
        addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        createStoryImageView.anchor(top: topAnchor, left: leftAnchor, paddingTop: 6, paddingLeft: 16) // 12
        createStoryImageView.setDimensions(height: 60, width: 60)
        createStoryImageView.layer.cornerRadius = 60/2.0
        createStoryImageView.backgroundColor = .secondarySystemBackground
        
        plusImageView.anchor(bottom: bottomAnchor, right: rightAnchor, paddingBottom: 8, paddingRight: 4)
        plusImageView.setDimensions(height: 25, width: 25)
        plusImageView.layer.cornerRadius = 25/2.0
        
        nameLabel.anchor(top: createStoryImageView.bottomAnchor, left: leftAnchor, paddingTop: 12, paddingLeft: 14)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Helper
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        createStoryImageView.sd_setImage(with: viewModel.profileImageURL, for: .normal)
    }
    
    // MARK: - Actions
    
    @objc func didTapUploadHistory() {
        guard let viewModel = self.viewModel else { return }
        delegate?.cell(self, didTapActionButtonFor: viewModel.user)
    }
}
