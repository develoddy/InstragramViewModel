//
//  CommentEmptyLabel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 27/1/23.
//

import UIKit


/*protocol CommentEmptyLabelViewDelegate: AnyObject {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView)
}*/


struct CommentEmptyLabelViewViewModel {
    let text: String
    let actionTitle: String
}

class CommentEmptyLabelView: UIView {

    //weak var delegate: ActionLabelViewDelegate?
    
    var viewModel: CommentEmptyLabelViewViewModel? {
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
    
    /*private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.link, for: .normal)
        return button
    }()*/
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        addSubview(titlelabel)
        addSubview(textLabel)
        //button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /*@objc func didTapButton() {
        delegate?.actionLabelViewDidTapButton(self)
    }*/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        /**
         label.frame = CGRect(x: 0, y: 0, width: width, height: height-4)
         button.frame = CGRect(x: 0, y: height-40, width: width, height: 40)
         **/
        let titlelabelSize = titlelabel.sizeThatFits(frame.size)
        titlelabel.frame = CGRect(x: 10, y: height/3, width: width-20, height: titlelabelSize.height).integral
        
        let textLabelSize = textLabel.sizeThatFits(frame.size)
        textLabel.frame = CGRect(x: 10, y: titlelabel.bottom, width: width-20, height: textLabelSize.height).integral
 
    }
    
    //func configure(with viewModel: ActionLabelViewViewModel) {
    func configure() {
        guard let viewModel = self.viewModel else { return }
        titlelabel.text = viewModel.text
        textLabel.text = viewModel.actionTitle
        //button.setTitle(viewModel.actionTitle, for: .normal)
    }
}
