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
    func updatePostViewControllerDidFinishUploadingPost(_ controller: UploadPostViewController)
}

class UploadPostViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = UploadPostViewModel()
    
    weak var delegate: UploadPostViewControllerDelegate?
    
    var currentUser: User?
    
    var typeAction = ""
    
    var selectedimage: UIImage? {
        didSet {
            photoImageView.image = selectedimage
        }
    }
    
    var selectedimageName: String? {
        didSet {
            photoImageView.sd_setImage(with: URL(string: selectedimageName ?? "") )
        }
    }
    
    var post: Post? {
        didSet {
            captionTextView.text = post?.caption
        }
    }
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var captionTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = .systemFont(ofSize: 16, weight: .semibold)
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
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        captionTextView.becomeFirstResponder()
    }
    
    // MARK: - Helpers
    
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Upload Post"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        if typeAction == "update" {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "update",
                style: .done,
                target: self, action: #selector(didTapUpdate)
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "Listo",
                style: .done,
                target: self, action: #selector(didTapDone)
            )
        }
        
        view.addSubview(photoImageView)
        photoImageView.setDimensions(height: 180, width: 180)
        photoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 10)
        photoImageView.centerX(inView: view)
        photoImageView.layer.cornerRadius = 10
        
        view.addSubview(captionTextView)
        captionTextView.anchor(
            top: photoImageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 16,
            paddingLeft: 12,
            paddingRight: 12,
            height: 64
        )
        
        view.addSubview(characterCountLabel)
        characterCountLabel.anchor(
            bottom: captionTextView.bottomAnchor,
            right: view.rightAnchor,
            paddingBottom: -8,
            paddingRight: 12
        )
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
        post.caption = captionTextView.text
        
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
            strongSelf.delegate?.updatePostViewControllerDidFinishUploadingPost(strongSelf)
        }
    }
    
    // Upload Post
    @objc func didTapDone() {
        guard let caption = captionTextView.text else { return }
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
            captionTextView.placeholderText = "Enter caption.."
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            captionTextView.placeholderText = "Enter caption.."
        }
        checkMaxLength(textView)
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
    }
}
