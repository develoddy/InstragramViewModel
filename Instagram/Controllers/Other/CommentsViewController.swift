//
//  CommentsViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit

class CommentsViewController: UICollectionViewController {

    // MARK: - Properties
    
    var viewModel = CommentViewModel()
    
    
    private lazy var commentInputView: CommentInputAccesoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let cv = CommentInputAccesoryView(frame: frame)
        cv.delegate = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    init(post: Post) {
        viewModel.post = post
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollections()
        bind()
        fetchComments()
    }
    
    override var inputAccessoryView: UIView? {
        get { return commentInputView }
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
        collectionView.frame = view.bounds
    }
    
    //MARK: - ViewModel
    
    private func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func fetchComments() {
        guard let postId = viewModel.post?.postId else {
            return
        }
        viewModel.fetchComments(forPost: postId)
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Comments"
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollections() {
        view.addSubview(collectionView)
        view.addSubview(collectionView)
        collectionView.register(
            ListCommentsCollectionViewCell.self,
            forCellWithReuseIdentifier: ListCommentsCollectionViewCell.identifier
        )
        
        collectionView.register(
            CommentsHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CommentsHeaderCollectionReusableView.identifier
        )
        
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    // MARK: - Actions
    
}

// MARK: - UICollectionViewDataSource
extension CommentsViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ListCommentsCollectionViewCell.identifier,
            for: indexPath
        ) as? ListCommentsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBackground
        cell.configure(with: ListCommentsCollectionViewCellViewModel(comment: viewModel.cellForRowAt(indexPath: indexPath)))
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension CommentsViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let uid = viewModel.cellForRowAt(indexPath: indexPath).uid
        viewModel.fetchUser(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                let vc = ProfileViewController(user: user)
                self?.navigationItem.largeTitleDisplayMode = .never
                self?.navigationController?.pushViewController(vc, animated: true)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension CommentsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = ListCommentsCollectionViewCellViewModel(comment: viewModel.cellForRowAt(indexPath: indexPath))
        let height = viewModel.size(forWidth: view.frame.width).height + 32
        return CGSize(width: view.frame.width, height: height)
    }
    
    /**override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CommentsHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? CommentsHeaderCollectionReusableView, kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        header.backgroundColor = .systemBackground
        return header
    }*/
}


// MARK: - CommentInputAccesoryViewDelegate

extension CommentsViewController: CommentInputAccesoryViewDelegate {
    func inputView(_ inputView: CommentInputAccesoryView, wantsToUploadComment comment: String) {
        
        guard let tab = self.tabBarController as? TabBarViewController else { return }
        guard let currentUser = tab.user  else { return }
        
        self.showLoader(true)
        
        viewModel.uploadComment(comment: comment, postID: viewModel.post?.postId ?? "", user: currentUser) { error in
            self.showLoader(false)
            inputView.clearCommentTextView()
        }
        
        // Uploader Notification
        self.viewModel.uploadNotification(
            toUid: viewModel.post?.ownerUid ?? "",
            fromUser: currentUser,
            type: .comment,
            post: viewModel.post)
    }
    
    
}

