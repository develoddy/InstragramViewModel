//
//  ProfileViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit
import Firebase

class ProfileViewController: UICollectionViewController {
    
    // MARK: - Propertie
    private var user: User?
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollections()
    }
    
    // MARK: - API

    
    // MARK: - Helpers
    
    private func configureUI() {
        title = user?.username
        collectionView.backgroundColor = .systemBackground
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
}

extension ProfileViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePhotosCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfilePhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .red
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = PostsSettingViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeaderCollectionReusableView.identifier, for: indexPath) as? ProfileHeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        if let user = user {
            header.configure(with: ProfileHeaderViewModel(user: user))
        }
        header.delegate = self
        header.backgroundColor = .systemBackground
        return header
    }
    
}


// MARK: - Profile Collection Delegate Flow Layout
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


// MARK: - Profile header
extension ProfileViewController: ProfileHeaderCollectionReusableViewDelegate {
    
    func ProfileHeaderCollectionReusableViewDidTapPosts(_ posts: String) {
        self.collectionView.scrollToItem(
            at: IndexPath(row: 0,section: 0),
            at: .top,
            animated: true
        )
    }
    
    // Followers
    func ProfileHeaderCollectionReusableViewDidTapFollowers(_ followers: String) {
        
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
        
    }
    
    // Followings
    func ProfileHeaderCollectionReusableViewDidTapFollowings(_ followings: String) {
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
    }
}
