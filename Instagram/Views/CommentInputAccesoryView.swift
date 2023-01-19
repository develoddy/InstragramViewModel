//
//  CommentInputAccesoryView.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import UIKit

protocol CommentInputAccesoryViewDelegate: AnyObject {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String)
}

class CommentInputAccesoryView: UIView {

    // MARK: - Properties
    
    weak var delegate: CommentInputAccesoryViewDelegate?
    
    private let commentTextView: InputTextView = {
        let textView = InputTextView()
        textView.placeholderText = "Enter comment.."
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.isScrollEnabled = false
        textView.placeHolderShouldCenter = true
        return textView
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(handleCommentUpload), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lefecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        
        addSubview(commentTextView)
        addSubview(postButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postButton.anchor(
            top: topAnchor,
            right: rightAnchor,
            paddingRight: 8
        )
        postButton.setDimensions(height: 50, width: 50)
        
        commentTextView.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: safeAreaLayoutGuide.bottomAnchor,
            right: postButton.leftAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingBottom: 8,
            paddingRight: 8
        )
        let divider = UIView()
        divider.backgroundColor = .lightGray
        addSubview(divider)
        divider.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    // MARK: - Helpers
    func clearCommentTextView() {
        commentTextView.text = nil
        commentTextView.placeholderLabel.isHidden = false
    }
    
    // MARK: - Actions
    @objc func handleCommentUpload() {
        delegate?.inputView(self, wantsToUploadComment: commentTextView.text)
    }

}
