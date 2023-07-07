//
//  EditTextFieldViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 2/2/23.
//

import UIKit


protocol EditTextFieldViewControllerDelegate: AnyObject {
    func inputView(controller: EditTextFieldViewController, wantsToUploadLabel label: String, wantsToUploadValue value: String)
}


class EditTextFieldViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: EditTextFieldViewControllerDelegate?
    
    var model: FormEditProfileTableViewCellViewModel? {
        didSet {
            label.text = model?.label
            textView.text = model?.value
        }
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private lazy var textView: InputTextView = {
        let textView = InputTextView()
        textView.font = .systemFont(ofSize: 14, weight: .regular)
        textView.delegate = self
        textView.placeHolderShouldCenter = false
        return textView
    }()
    
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.text = "Usa el nombre por el que te conoce todo el mundo, ya sea tu nombre completo, apodo o nombre comercial, para que las personas descubran tu cuenta. solo puedes cambiar dos veces en un pazo de 15 días."
        label.numberOfLines = 0
        label.textColor = .gray
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        textView.becomeFirstResponder()
        
        let labelSize = label.sizeThatFits(view.frame.size)
        label.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingRight: 8,
            height: labelSize.height
        )
        
        let textViewlSize = textView.sizeThatFits(view.frame.size)
        textView.anchor(
            top: label.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 4,
            paddingLeft: 8,
            paddingRight: 8,
            height: textViewlSize.height
        )
        
        let descriptionLabelSize = descriptionLabel.sizeThatFits(view.frame.size)
        descriptionLabel.anchor(
            top: textView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingRight: 8,
            height: descriptionLabelSize.height
        )
    }
    

    // MARK: - Helper
    private func configureUI() {
        view.addSubview(label)
        view.addSubview(textView)
        view.addSubview(descriptionLabel)
        view.backgroundColor = .systemBackground
        
        navigationItem.title = model?.label
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self, action: #selector(didTapDone)
        )
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    // MARK: - Actions
    
    // Update value user
    @objc func didTapDone() {
        //delegate?.inputView(controller: self, wantsToUploadValue: textView.text)
        guard let model = self.model else { return }
        delegate?.inputView(controller: self, wantsToUploadLabel: model.label, wantsToUploadValue: textView.text)
    }
}

extension EditTextFieldViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            self.textView.placeholderText = self.model?.placeHolder
        }
        navigationItem.rightBarButtonItem?.isEnabled = model?.value == textView.text ? false : true
    }
}
