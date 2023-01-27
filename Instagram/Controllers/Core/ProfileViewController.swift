//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit



class ProfileViewController: UICollectionViewController {
    
    
    // MARK: - Properties
  
    private var viewModel = ProfileViewModel()
    
    init(user: User) {
        viewModel.updatePropertiesUser(user: user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollections()
        bind()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - ViewModels
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    func fetchData() {
        viewModel.fetchPosts(uid: viewModel.getUID()) { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
        }
        
        viewModel.checkIfUserIsFollowed { [weak self] isFollowed in
            self?.viewModel.updatePropertiesIsFollwed(isFollowed: isFollowed)
        }
        
        viewModel.fetchUserStats(uid: viewModel.getUID()) { [weak self] stats in
            self?.viewModel.updatePropertiStats(stats: stats)
        }
    }
    

    // MARK: - Helpers

    private func configureUI() {
        title = viewModel.getUsername()
        collectionView.backgroundColor = .systemBackground
    }
    
    private func configureCollections() {
        collectionView.backgroundColor = .white
        collectionView.register(
            ProfilePhotosCollectionViewCell.self,
            forCellWithReuseIdentifier: ProfilePhotosCollectionViewCell.identifier
        )
        
        collectionView.register(
            ProfileHeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier
        )
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
        
    // MARK: - Action
    
    @objc func handleRefresh() {
        viewModel.posts.removeAll()
        fetchData()
        refresher.endRefreshing()
    }
}


// MARK: - UIColletionViewDasource

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if viewModel.checkIfIsFolloweds(vc: self) {
            if viewModel.numberOfRowsInSection(section: section) == 0 {
                collectionView.setEmptyMessage("Aún no hay publicaciones.")
                return 0
            } else {
                collectionView.restore()
            }
            return viewModel.numberOfRowsInSection(section: section)
        } else {
            collectionView.setEmptyMessage("Esta cuenta es privada. \nSigue esta cuenta para ver sus fotos y videos.")
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePhotosCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfilePhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = FeedCollectionViewCellViewModel(
            post: viewModel.cellForRowAt(indexPath: indexPath)
        )
        cell.backgroundColor = .lightGray
        return cell
    }
}


// MARK: - UIColletionViewDelegate

extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        FeedPresenter.shared.startFeed(
            from: self,
            post: viewModel.cellForRowAt(indexPath: indexPath)
        )
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier,
            for: indexPath
        ) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        /***
         * Comprobar si el usuario actual sigue al perfil que está visitando y
         * tambien se comprueba si el perfil que se visita tiene publicaciones.
         ***/
        if viewModel.checkIfIsFolloweds(vc: self) && viewModel.posts.count != 0 {
            header.gridButton.isHidden = false
            header.listButton.isHidden = false
            header.bookmarkButton.isHidden = false
        }
        
        if let user = viewModel.fetchUser() {
            header.configure(
                with: ProfileHeaderViewModel(user: user)
            )
        }
        header.delegate = self
        header.backgroundColor = .systemBackground
        return header
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 1
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}


// MARK: - ProfileHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
 
    // Button Follow / Following
    func header(
        _ profileHeader: ProfileHeaderCollectionReusableView,
        didTapActionButtonFor user: User
    ) {
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser {
            debugPrint("Debug: Show edit profile here")
        } else if user.isFollwed {
            viewModel.unfollow { [weak self] error in
                self?.viewModel.updatePropertiesIsFollwed(isFollowed: false)
                self?.viewModel.updateUserFeedAfterFollowing(
                    user: user,
                    didFollow: false
                )
                profileHeader.gridButton.isHidden = true
                profileHeader.listButton.isHidden = true
                profileHeader.bookmarkButton.isHidden = true
                self?.fetchData()
            }
        } else {
            viewModel.follow { [weak self] error in
                self?.viewModel.updatePropertiesIsFollwed(isFollowed: true)
                self?.viewModel.uploadNotification(
                    toUid: user.uid,
                    fromUser: currentUser,
                    type: .follow
                )
                
                guard let user = self?.viewModel.user else { return }
                self?.viewModel.updateUserFeedAfterFollowing(
                    user: user,
                    didFollow: true
                )
                
                self?.fetchData()
            }
        }
    }
    
    // Count followings
    func header(
        _ profileHeader: ProfileHeaderCollectionReusableView,
        wantsToFollowing uid: String
    ) {
        FollowSettingPresenter.shared.startFollwSetting(
            from: self,
            uid: uid,
            vcName: "followings"
        )
    }
    
    // Count followers
    func header(
        _ profileHeader: ProfileHeaderCollectionReusableView,
        wantsToFollower uid: String
    ) {
        FollowSettingPresenter.shared.startFollwSetting(
            from: self,
            uid: uid,
            vcName: "followers"
        )
    }
}
