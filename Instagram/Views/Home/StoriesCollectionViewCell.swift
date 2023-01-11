//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 11/1/23.
//

import UIKit

class StoriesCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "StoriesCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: String) {
    }
}
