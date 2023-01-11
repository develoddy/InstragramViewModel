//
//  HomeViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit

enum FeedSectionType {
    case stories(viewModels: String) // 1
    case feeds(viewModels: String) // 2
}


class HomeViewController: UIViewController {

    // MARK: - Properties
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return HomeViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    private var sections = [FeedSectionType]()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        configureCollectionView()
        configureModels()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "gear"),
            style: .done,
            target: self,
            action: #selector(didTapSettings)
        )
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }

    
    // MARK: - Helpers
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        // collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(FeedCollectionViewCell.self, forCellWithReuseIdentifier: FeedCollectionViewCell.identifier)
        collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: StoriesCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        collectionView.reloadData()
    }
    
    private func configureModels() {
        sections.append(.stories(viewModels: "-"))
        sections.append(.feeds(viewModels: "x"))
    }
    
    
    // MARK: - Actions
    
    @objc func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Setting"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - CollectionView

extension HomeViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       let type = sections[section]
        switch type {
        case .feeds(_):
            return 5
        case .stories(_):
            return 5
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let type = sections[indexPath.section]
        switch type {
        case .stories(_):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoriesCollectionViewCell.identifier,
                for: indexPath
            ) as? StoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .lightGray
            return cell
            
        case .feeds(_):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedCollectionViewCell.identifier,
                for: indexPath
            ) as? FeedCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .systemBackground
            return cell
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
                    widthDimension: .absolute(120),
                    heightDimension: .absolute(120)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(120),
                    heightDimension: .absolute(200)),
                subitem: item,
                count: 1)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .absolute(120),
                    heightDimension: .absolute(200)),
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
                    heightDimension: .absolute(400+170)),
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
