//
//  SearchViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = SearchViewModel()
    
    let searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Buscar"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection? in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(150)),
                subitem: item,
                count: 3
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
            
            return NSCollectionLayoutSection(group: group)
        })
    )
    
    private var inSearchMode: Bool {
        searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let refresher = UIRefreshControl()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        configureCollections()
        bind()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    
    // MARK: - ViewModel
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    
    private func fetchPosts() {
        
        
        viewModel.fetchFeedPosts { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
        }
    }

    // MARK: - Helpers
    
    private func configureUI() {
        title = "Search"
        view.backgroundColor = .systemBackground
    }
    
    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func configureCollections() {
        view.addSubview(collectionView)
        collectionView.register(
            ProfilePhotosCollectionViewCell.self, forCellWithReuseIdentifier: ProfilePhotosCollectionViewCell.identifier
        )
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        self.collectionView.refreshControl = refresher
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        viewModel.posts.removeAll()
        fetchPosts()
        refresher.endRefreshing()
    }
}


// MARK: - Search Result

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
              let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
        }
        resultsController.delegate = self
        
        // UserService
        UserService.shared.fetchUsers { result in
            switch result {
            case .success(let users):
                resultsController.update(with: users)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    }
}


// MARK: - SearchResultsViewControllerDelegate



extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ result: User) {
        let vc = ProfileViewController(user: result)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - UICollectionViewDataSource

extension SearchViewController:  UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProfilePhotosCollectionViewCell.identifier,
            for: indexPath
        ) as? ProfilePhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.viewModel = FeedCollectionViewCellViewModel(
            post: viewModel.cellForRowAt(indexPath: indexPath)
        )
        cell.backgroundColor = .systemYellow
        return cell
    }
}


// MARK: - UICollectionViewDelegate
extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        FeedPresenter.shared.startFeed(from: self, post: viewModel.cellForRowAt(indexPath: indexPath))
    }
}
