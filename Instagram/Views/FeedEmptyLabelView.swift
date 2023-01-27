//
//  FeedEmptyLabelView.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 27/1/23.
//

import UIKit


struct FeedEmptyLabelViewViewModel {
    let text: String
    let actionTitle: String
}

class FeedEmptyLabelView: UIView {

    var viewModel: FeedEmptyLabelViewViewModel? {
        didSet {
            configure()
        }
    }
    
    private let titlelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubview(titlelabel)
        addSubview(textLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let titlelabelSize = titlelabel.sizeThatFits(frame.size)
        titlelabel.frame = CGRect(x: 10, y: height/3, width: width-20, height: titlelabelSize.height).integral
        
        let textLabelSize = textLabel.sizeThatFits(frame.size)
        textLabel.frame = CGRect(x: 10, y: titlelabel.bottom, width: width-20, height: textLabelSize.height).integral
    }
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        titlelabel.text = viewModel.text
        textLabel.text = viewModel.actionTitle
    }
}
