//
//  UploadHistoryViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/2/23.
//

import UIKit

protocol UploadHistoryViewControllerDelegate: AnyObject {
    func uploadUploadHistoryViewControllerDidFinishUploadingHistory(_ controller: UploadHistoryViewController)
}

class UploadHistoryViewController: UIViewController {

    // MARK: - Helper
    
    var viewModel = UploadHistoryViewModel()
    
    weak var delegate: UploadHistoryViewControllerDelegate?
    
    var selectedImage: UIImage? {
        didSet { imageView.image = selectedImage }
    }
    
    var currentUser: User? 
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    // MARK: - Lefecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: view.bounds.size.height/6
        )
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
    }
    
    // MARK: - Helper
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
    }
    
    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self, action: #selector(didTapDone)
        )
    }

    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
        guard let user = currentUser else { return }
        guard let image = selectedImage else { return }
        showLoader(true)
        viewModel.uploadHistory(image: image, currentUser: user ) { [ weak self ] err in
            guard let stronfSelf = self else { return }
            stronfSelf.showLoader(false)
            if let err = err {
                print("DEBUG: Failed to upload : \(err.localizedDescription)")
                return
            }
            stronfSelf.delegate?.uploadUploadHistoryViewControllerDidFinishUploadingHistory(stronfSelf)
        }
    }
}
