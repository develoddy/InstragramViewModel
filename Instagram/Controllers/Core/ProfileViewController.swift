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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollections()
        updateUI()
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
        
        viewModel.fetchPosts(uid: viewModel.getUID())
        
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
        ///collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
    }
    
    func updateUI() {
        viewModel.refreshData = { [weak self] in
            DispatchQueue.main.async  {
                self?.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Action
}


// MARK: - UIColletionViewDasource

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePhotosCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfilePhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        let post = viewModel.cellForRowAt(indexPath: indexPath)
        cell.configure(with: FeedCollectionViewCellViewModel(post: post))
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        if let user = viewModel.fetchUser() {
            header.configure(with: ProfileHeaderViewModel(user: user))
        }
        
        header.delegate = self
        header.backgroundColor = .systemBackground
        return header
    }
}


// MARK: - UIColletionViewDelegate

extension ProfileViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        FeedPresenter.shared.startFeed(from: self, post: viewModel.cellForRowAt(indexPath: indexPath))
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 2)/3
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 240)
    }
}


// MARK: - ProfileHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    
    
    func header(_ profileHeader: ProfileHeaderCollectionReusableView, didTapActionButtonFor user: User) {
        
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let currentUser = tab.user else { return }
        
        if user.isCurrentUser {
            debugPrint("Debug: Show edit profile here")
        } else if user.isFollwed {
            viewModel.unfollow { [weak self] error in
                self?.viewModel.updatePropertiesIsFollwed(isFollowed: false)
            }
        } else {
            viewModel.follow { [weak self] error in
                self?.viewModel.updatePropertiesIsFollwed(isFollowed: true)
                
                // Uploader Notification
                self?.viewModel.uploadNotification(
                    toUid: user.uid,
                    fromUser: currentUser,
                    type: .follow)
            }
        }
    }
    
    
    /*func ProfileHeaderCollectionReusableViewDidTapPosts(_ posts: String) {
        self.collectionView.scrollToItem(
            at: IndexPath(row: 0,section: 0),
            at: .top,
            animated: true
        )
    }*/
    
    // Followers
    /*func ProfileHeaderCollectionReusableViewDidTapFollowers(_ followers: String) {
        
        var mockData = [UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(
                username: "@joer",
                namm: "Joe Smith",
                type: x % 2 == 0 ? .following: .not_following))
        }
        
        let vc = FollowSettingViewController(data: mockData, vc: "followers")
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }*/
    
    // Followings
    /*func ProfileHeaderCollectionReusableViewDidTapFollowings(_ followings: String) {
        var mockData = [UserRelationship]()
        for x in 0..<10 {
            mockData.append(UserRelationship(
                username: "@joer",
                namm: "Joe Smith",
                type: x % 2 == 0 ? .following: .not_following))
        }
        let vc = FollowSettingViewController(data: mockData, vc: "followings")
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func ProfileHeaderCollectionReusableViewDidTapEditProfile(_ editProfile: String) {
        print(editProfile)
    }*/
}
