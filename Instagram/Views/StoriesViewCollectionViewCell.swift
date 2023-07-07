//
//  StoriesViewCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/2/23.
//

import UIKit

protocol StoriesViewCollectionViewCellDelegate: AnyObject {
    func cell(_ storieViewCell: StoriesViewCollectionViewCell )
}

class StoriesViewCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static var identifier = "StoriesViewCollectionViewCell"
    
    weak var delegate: StoriesViewCollectionViewCellDelegate?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    lazy var startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 0.5
        button.addTarget(self, action: #selector(didTapStart), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray
        addSubview(imageView)
        addSubview(startButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.anchor(
            top: safeAreaLayoutGuide.topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            paddingTop: 20
        )
        imageView.heightAnchor.constraint( equalTo: widthAnchor, multiplier: 1 ).isActive = true
        
        startButton.anchor( top: imageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24 )
    }
    
    
    // MARK: - Helper
    
    
    // MARK: - Actions
    
    @objc func didTapStart() {
        delegate?.cell(self)
    }
}
