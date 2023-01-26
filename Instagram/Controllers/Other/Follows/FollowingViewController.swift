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
                        heightDimension: .absolute(100)
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
    
    public func usersFollowings(users: [User]) {
        viewModel.usersFollowings = users
        checkIfUserIsFollowed()
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


// MARK: - UiCollection Delegate & Datasource

extension FollowingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersFollowsCollectionViewCell.identifier, for: indexPath) as? UsersFollowsCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBackground
        cell.viewModel = UsersFollowsCollectionViewCellViewModel(user: self.viewModel.cellForRowAt(indexPath: indexPath))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
