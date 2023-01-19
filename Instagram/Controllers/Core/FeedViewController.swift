//
//  FeedViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
// https://github.com/firebase/firebase-ios-sdk


import UIKit

enum FeedSectionType {
    case stories(viewModels: String) // 1
    case feeds(viewModels: [FeedCollectionViewCellViewModel]) // 2
}


class FeedViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel = FeedViewModel()
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return FeedViewController.createSectionLayout(section: sectionIndex)
        }
    )
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureNavigationItem()
        fetchPosts()
        bind()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    
    // MARK: - ViewModels
    
    private func fetchPosts() {
        viewModel.fetchPosts()
        self.collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: StoriesCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    private func bind() {
        viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                // self.activity.stopAnimating
            }
        }
    }
    
    func configureNavigationItem() {
        confireColorNavigation()
        setupRightNavItems()
    }
    
    func confireColorNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupRightNavItems() {
        let buttonGear = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
        
        let buttonAdd = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        navigationItem.rightBarButtonItems = [
            buttonGear,
            buttonAdd
        ]
    }
    
    
    // MARK: - Actions
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
            
    @objc private func didTapAdd() {
        // Add post
    }
    
    @objc func handleRefresh() {
        //viewModel.refreshData
        // removeAll
        // FetchModel
        viewModel.sections.removeAll()
        fetchPosts()
    }
}


// MARK: - CollectionView

extension FeedViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = viewModel.cellForRowAt(indexPath: indexPath)
        switch type {
        case .stories(_):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoriesCollectionViewCell.identifier,
                for: indexPath
            ) as? StoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure()
            return cell
            
        case .feeds(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedCollectionViewCell.identifier,
                for: indexPath
            ) as? FeedCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.backgroundColor = .systemBackground
            cell.delegate = self
            
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = viewModel.cellForRowAt(indexPath: indexPath)
        switch section {
        case .stories(_):
            let vc = SettingStorieViewController()
            vc.navigationItem.largeTitleDisplayMode = .never
            //vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        case .feeds(let viewModel):
            print("DEBUG: DidSelectItem: ")
            print(viewModel)
            
            let vc = ProfileViewController(user: User(dictionary: [:]))
            vc.title = "name"
            vc.navigationItem.largeTitleDisplayMode = .never
            navigationController?.pushViewController(vc, animated: true)
        }
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
                    widthDimension: .absolute(80),
                    heightDimension: .absolute(80)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(80),
                    heightDimension: .absolute(100)),
                subitem: item,
                count: 1)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(80),
                    heightDimension: .absolute(100)),
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
        case 1:
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
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(390)),
                subitem: item,
                count: 1)
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            return section
        }
    }
}


// MARK: - Delegates buttons
extension FeedViewController: FeedCollectionViewCellDelegate {
    
    
    func feedCollectionDidTapLike(_ user: String) {
        // Like
    }
    
    func feedCollectionDidTapComment(_ user: String) {
        /*let vc = CommentsViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)*/
        PostCommentPresenter.shared.startComment(from: self, user: "vvvcomm")
    }
    
    func feedCollectionDidTapShare(_ user: String) {
        // Share
    }
    
    func feedCollectionDidTapMoreComments(_ user: String) {
        // More Comment
    }
}
