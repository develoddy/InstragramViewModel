//
//  FormEditProfileTableViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 1/2/23.
//

import UIKit

struct FormEditProfileTableViewCellViewModel {
    let label: String
    let placeHolder: String
    var value: String?
}


class FormEditProfileTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FormEditProfileTableViewCell"
    
    var viewModel: FormEditProfileTableViewCellViewModel? {
        didSet {
            configure()
        }
    }
    
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private let labelText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var fieldText: InputTextView = {
        let textView = InputTextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.placeHolderShouldCenter = false
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(labelText)
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Asing frames
        formLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.width/3,
            height: contentView.height
        )
        labelText.frame = CGRect(
            x: formLabel.right+5,
            y: 0,
            width: contentView.width-10-formLabel.width,
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        formLabel.text = nil
        labelText.text = nil
    }
    
    func configure() {
        guard let viewModel = self.viewModel else { return }
        formLabel.text = viewModel.label
        labelText.text = viewModel.value
    }
}
