//
//  PostsSettingViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import UIKit
import Firebase

class PostsSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = PostsSettingViewControllerViewModel()
    
    //var posts: [Post] = []
    var indice: Int = 0
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return PostsSettingViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollections()
        fetchPosts()
        bind()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    // MARK: - Helpers
    
    private func fetchPosts() {
        let uid = Auth.auth().currentUser?.uid
        viewModel.fetchPosts(uid: uid ?? "")
    }
 
    
    private func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func configureUI() {
        title = "Posts"
        view.backgroundColor = .orange
    }
    
    private func configureCollections() {
        view.addSubview(collectionView)
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
    }
    
    // MARK: - Actions
    
}


// MARK: - UICollectionViewDelegate && UICollectionViewDataSource

extension PostsSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.identifier,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBackground
        
        cell.delegate = self
        
        //print("DEBUG: CELL indice de ProfileView")
        //print(self.indice)
        
        //print("DEBUG: CELL indice de PostSetting")
        //print(viewModel.posts[indexPath.section])
        
        /*print(indexPath.section)
        if indexPath.section == self.indice {
            print("DEBUG: IF ")
            self.collectionView.scrollToItem(at: IndexPath(row: 0,section: indexPath.section),at: .top,animated: true)
            print(viewModel.posts[indexPath.section])
            let post = viewModel.posts[indexPath.section]
            cell.configure(with: FeedCollectionViewCellViewModel(post: post))
        }*/
        
        self.collectionView.scrollToItem(at: IndexPath(row: 0 ,section: self.indice ),at: .top,animated: true)
        //print(viewModel.posts[indexPath.section])
        let post = viewModel.cellForRowAt(indexPath: indexPath)
        cell.configure(with: FeedCollectionViewCellViewModel(post: post))
        
        
        
        
        // Comparar el indice que viene de profileView con data[index.row]
        
        return cell
    }
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        
        let supplementaryViews = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(10)
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
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0)
        
        // Group
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(400+200)),
            subitem: item,
            count: 1)
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        //section.orthogonalScrollingBehavior = .groupPaging
        section.orthogonalScrollingBehavior = .none
        section.boundarySupplementaryItems = supplementaryViews
        
        return section
    }
}

extension PostsSettingViewController: FeedCollectionViewCellDelegate {
    
    func feedCollectionDidTapLike(_ user: String) {
        // Like
    }
    
    func feedCollectionDidTapComment(_ user: String) {
        PostCommentPresenter.shared.startComment(from: self, user: "vvvcomm")
    }
    
    func feedCollectionDidTapShare(_ user: String) {
        // Shared
    }
    
    func feedCollectionDidTapMoreComments(_ user: String) {
        // Ver más comentarios
        PostCommentPresenter.shared.startComment(from: self, user: "vvvcomm")
    }
    
}
