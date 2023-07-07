//
//  FollowingViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import UIKit

class FollowingViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = FollowingViewModel()
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            
            let supplementaryViews = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(20)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top)
            ]
            
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(70)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = supplementaryViews
            return section
        })
    )
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollections()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    // MARK: - ViewModels
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    public func usersFollowings(uid: String) {
        viewModel.fetchFollowings(uid: uid) { [weak self] in
            self?.checkIfUserIsFollowed()
        }
    }
    
    private func checkIfUserIsFollowed() {
        viewModel.usersFollowings.forEach { user in
            guard user.type == .follow else { return }
            viewModel.checkIfUserIsFollowed(uid: user.uid) { isFollowed in
                if let index = self.viewModel.usersFollowings.firstIndex(where: { $0.uid == user.uid }) {
                    self.viewModel.usersFollowings[index].isFollwed = isFollowed
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Following"
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollections() {
        view.addSubview(collectionView)
        collectionView.register(UsersFollowsCollectionViewCell.self, forCellWithReuseIdentifier: UsersFollowsCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Actions

}

// MARK: - UICollectionViewDataSource

extension FollowingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersFollowsCollectionViewCell.identifier, for: indexPath) as? UsersFollowsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBackground
        cell.viewModel = UsersFollowsCollectionViewCellViewModel(user: self.viewModel.cellForRowAt(indexPath: indexPath), cellName: "followings")
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FollowingViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        showLoader(true)
        UserService.shared.fetchUser(uid: viewModel.cellForRowAt(indexPath: indexPath).uid) { result in
            self.showLoader(false)
            switch result {
            case .success(let user):
                ProfilePresenter.shared.startProfile(from: self, user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - UsersFollowsCollectionViewCellDelegate

extension FollowingViewController: UsersFollowsCollectionViewCellDelegate {
    
    func cell(_ cell: UsersFollowsCollectionViewCell, wantsTounFollow uid: String) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                self.showLoader(true)
                self.viewModel.unfollow(uid: uid) { _ in
                    self.showLoader(false)
                    cell.viewModel?.user.isFollwed.toggle()
                    self.viewModel.updateUserFeedAfterFollowing(
                        user: user,
                        didFollow: false
                    )
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func cell(_ cell: UsersFollowsCollectionViewCell, wantsToFollow uid: String) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                self.showLoader(true)
                self.viewModel.follow(uid: uid) { _ in
                    self.showLoader(false)
                    cell.viewModel?.user.isFollwed.toggle()
                    self.viewModel.updateUserFeedAfterFollowing(
                        user: user,
                        didFollow: true
                    )
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
