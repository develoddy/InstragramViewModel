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
    
    var indice = 0
    
    var uid: String = ""
    
    var collectionView: UICollectionView = UICollectionView(
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
        let uid = self.uid
        viewModel.fetchPosts(uid: uid)
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.identifier,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .systemBackground
        let post = self.viewModel.cellForRowAt(indexPath: indexPath)
        
        ///cell.configure(with: FeedCollectionViewCellViewModel(post: post))
        cell.viewModel = FeedCollectionViewCellViewModel(post: post)
        cell.delegate = self
        
        print("DEBUG : EXTERNO :\(self.indice)")
        print("DEBUG : INTERNO :\(indexPath.row)")
        
        collectionView.scrollToItem(at: IndexPath(row: self.indice, section: 0), at: .top, animated: true)
        collectionView.isPagingEnabled = false
        
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
        switch section {
        case 0:
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
                    heightDimension: .absolute(400+200)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            //section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        default:
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
                    heightDimension: .absolute(400+200)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            //section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            return section
        }
    }
}

extension PostsSettingViewController: FeedCollectionViewCellDelegate {
    
    func cell(_ cell: FeedCollectionViewCell, wantsToPost uid: String ) {
        
    }
    
    func cell(_ cell: FeedCollectionViewCell, wantsToShowProfileFor uid: String) {
        
    }
    
    func feedCollectionDidTapLike(_ cell: FeedCollectionViewCell, didLike post: Post) {
        
    }
    
    func feedCollectionDidTapComment(_ cell: FeedCollectionViewCell, wantsShowCommentFor post: Post) {
        //PostCommentPresenter.shared.startComment(from: self, post: )
        //print("DEBUG POST")
        //print(viewModel.posts)
    }
    
    
    func feedCollectionDidTapShare(_ user: String) {
        // Shared
    }
    
    func feedCollectionDidTapMoreComments(_ user: String) {
        // Ver más comentarios
        //PostCommentPresenter.shared.startComment(from: self, user: "vvvcomm")
    }
    
}
