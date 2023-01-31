//
//  UploadPostViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import UIKit
import SDWebImage

protocol UploadPostViewControllerDelegate: AnyObject {
    func uploadPostViewControllerDidFinishUploadingPost(_ controller: UploadPostViewController)
    func updatePostViewControllerDidFinishUploadingPost(_ controller: UploadPostViewController, wantsToPost post: Post)
}

extension UploadPostViewController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {}
}

class UploadPostViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = UploadPostViewModel()
    
    weak var delegate: UploadPostViewControllerDelegate?
    
    var type: String? {
        didSet { typeActionView = type }
    }
    
    var currentUser: User? {
        didSet { profileImageView.sd_setImage(with: URL(string: currentUser?.profileImageURL ?? "")) }
    }
    
    var selectedimage: UIImage? {
        didSet { postImageView.image = selectedimage }
    }
    
    var selectedimageName: String? {
        didSet { postImageView.sd_setImage(with: URL(string: selectedimageName ?? "") ) }
    }
    
    var post: Post? {
        didSet {
            ///captionTextView.text = post?.caption
            commentInputView.commentTextView.text = post?.caption
            profileImageView.sd_setImage(with: URL(string: post?.ownerImageURL ?? ""))
            usernameButton.setTitle(post?.ownerUsername, for: .normal)
        }
    }
    
    var typeActionView: String?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("User", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .semibold)
        return button
    }()
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        cv.commentTextView.delegate = self
        return cv
    }()
    
    /**private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.delegate = self
        textView.placeHolderShouldCenter = false
        return textView
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = "0/100"
        return label
    }()*/
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView}
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        ///captionTextView.becomeFirstResponder()
        commentInputView.commentTextView.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        if typeActionView == "update" {
            navigationItem.title = "Edit information"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Listo",
                style: .done,
                target: self, action: #selector(didTapUpdate)
            )
        } else {
            navigationItem.title = "New post"
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Listo",
                style: .done,
                target: self, action: #selector(didTapDone)
            )
        }
        
        view.addSubview(profileImageView)
        profileImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingTop: 12,
            paddingLeft: 12
        )
        profileImageView.setDimensions(height: 40, width: 40)
        profileImageView.layer.cornerRadius = 40 / 2
        
        view.addSubview(usernameButton)
        usernameButton.centerY(
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 8
        )
        view.addSubview(postImageView)
        postImageView.anchor(
            top: profileImageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8
        )
        postImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        /**view.addSubview(captionTextView)
        captionTextView.anchor(
            top: postImageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8,
            paddingLeft: 8,
            paddingRight: 8,
            height: 64
        )
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(
            bottom: captionTextView.bottomAnchor,
            right: view.rightAnchor,
            paddingBottom: -8,
            paddingRight: 12
        )*/
    }

    func checkMaxLength(_ textView: UITextView) {
        if (textView.text.count) > 100 {
            textView.deleteBackward()
        }
    }
    
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Update Post
    @objc func didTapUpdate() {
        guard var post = self.post else {
            return
        }
        ///post.caption = captionTextView.text
        post.caption = commentInputView.commentTextView.text
        
        showLoader(true)
        viewModel.updatePost(
            post: post
        ) { [weak self] error in
            self?.showLoader(false)
            guard let strongSelf = self else { return }
            if let error = error {
                print("DEBUG: Failed to upload : \(error.localizedDescription)")
                return
            }
            strongSelf.delegate?.updatePostViewControllerDidFinishUploadingPost(strongSelf, wantsToPost: post)
            
        }
    }
    
    // Upload Post
    @objc func didTapDone() {
        ///guard let caption = captionTextView.text else { return }
        guard let caption = commentInputView.commentTextView.text else { return }
        guard let image = selectedimage else { return }
        guard let user = currentUser else { return }
        
        showLoader(true)
        viewModel.uploadPost(
            caption: caption,
            image: image,
            user: user
        ) { [weak self] error in
            self?.showLoader(false)
            guard let strongSelf = self else { return }
            if let error = error {
                print("DEBUG: Failed to upload : \(error.localizedDescription)")
                return
            }
            strongSelf.delegate?.uploadPostViewControllerDidFinishUploadingPost(strongSelf)
        }
    }
}


// MARK: - UITextViewDelegate

extension UploadPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            ///captionTextView.placeholderText = "Enter caption.."
            commentInputView.commentTextView.placeholderText = "Enter caption..."
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            ///captionTextView.placeholderText = "Enter caption.."
            commentInputView.commentTextView.placeholderText = "Enter caption..."
        }
        checkMaxLength(textView)
        let count = textView.text.count
        ///characterCountLabel.text = "\(count)/100"
        commentInputView.characterCountLabel.text = "\(count)/100"
    }
}
