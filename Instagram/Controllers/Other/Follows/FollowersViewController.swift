//
//  FollowersViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import UIKit

class FollowersViewController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {
    
    
    // MARK: - Properties
    
    let searchController: UISearchController = {
        //let searc = SearchResultsViewController()
        let vc = UISearchController(searchResultsController: SearchResultsViewController())
        vc.searchBar.placeholder = "Songs, Artists, Albums"
        vc.searchBar.searchBarStyle = .minimal
        vc.definesPresentationContext = true
        return vc
    }()
    
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
    
    //private var data: [UserRelationship] = []
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearch()
        view.addSubview(collectionView)
        configureCollections() 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    

    // MARK: - Helpers
    
    private func configureUI() {
        title = "Followers"
        view.backgroundColor = .systemBlue
    }
    
    private func configureSearch() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
    }
    
    public func usersFollowers(users: [User]) {
        print("DEBUG: FollowersViewcontroller receive data")
        print(users)
    }
    
    private func configureCollections() {
        view.addSubview(collectionView)
        collectionView.register(UsersFollowsCollectionViewCell.self, forCellWithReuseIdentifier: UsersFollowsCollectionViewCell.identifier)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let _ = searchController.searchResultsController as? SearchResultsViewController,
                let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
        }
        // Delegate de SearhResultsViewController
        //resultsController.delegate = self
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        //
    }

}



// MARK: - UiCollection Delegate & Datasource

extension FollowersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UsersFollowsCollectionViewCell.identifier, for: indexPath) as? UsersFollowsCollectionViewCell else {
            return UICollectionViewCell()
        }
       
        //cell.backgroundColor = .systemYellow
        //let userRelationsship = UserRelationship(username: "xxx", namm: "namm", type: <#T##FollowState#>)
        //cell.configure(with: userRelationsship)
        //let userRelationsship = data[indexPath.row]
        //cell.configure(with: userRelationsship)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        /*let vc = PostsSettingViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)*/
    }
}

