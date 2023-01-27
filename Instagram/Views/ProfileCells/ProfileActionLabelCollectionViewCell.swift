//
//  ProfileActionLabelCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 27/1/23.
//

import UIKit

class ProfileActionLabelCollectionViewCell: UICollectionViewCell {
    
    static let indentifier = "ProfileActionLabelCollectionViewCell"
    
    var viewModel: ProfileActionLabelViewViewModel? {
        didSet {
            configure()
        }
    }
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        //isHidden = true
        addSubview(label)
        addSubview(button)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
        label.frame = CGRect(x: 0, y: 0, width: width, height: height-4)
        
    }
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        label.text = viewModel.text
        button.setTitle(viewModel.actionTitle, for: .normal)
    }
   
}
