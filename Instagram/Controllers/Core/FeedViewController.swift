//
//  FeedViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//


/*
 
 //
 //  ProfileViewController.swift
 //  Instagram
 //
 //  Created by Eddy Donald Chinchay Lujan on 4/1/23.
 //

 import UIKit


 class ProfileViewController: UIViewController {
     
     private var collectionView: UICollectionView = UICollectionView(
         frame: .zero,
         collectionViewLayout: UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
             
  
             // Item
             let item = NSCollectionLayoutItem(
                 layoutSize: NSCollectionLayoutSize(
                     widthDimension: .fractionalWidth(1.0),
                     heightDimension: .fractionalHeight(1.0)
                 )
             )
             
             item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 2, bottom: 1, trailing: 2)
             
             let verticalGroup = NSCollectionLayoutGroup.vertical(
                 layoutSize: NSCollectionLayoutSize(
                     widthDimension: .fractionalWidth(1),
                     heightDimension: .absolute(150)),
                 subitem: item,
                 count: 1)
             
             let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                 layoutSize: NSCollectionLayoutSize(
                     widthDimension: .fractionalWidth(1),
                     heightDimension: .absolute(150)),
                 subitem: verticalGroup,
                 count: 3)
             
             // Section
             let section = NSCollectionLayoutSection(group: horizontalGroup)
             section.boundarySupplementaryItems = [
                 NSCollectionLayoutBoundarySupplementaryItem(
                     layoutSize: NSCollectionLayoutSize(
                         widthDimension: .fractionalWidth(1),
                         heightDimension: .fractionalWidth(1)),
                     elementKind: UICollectionView.elementKindSectionHeader,
                     alignment: .top)
             ]
             
             return section
         }
     )
     

     override func viewDidLoad() {
         super.viewDidLoad()
         configureUI()
         configureCollectionView()
     }
     
     override func viewDidLayoutSubviews() {
         super.viewDidLayoutSubviews()
         collectionView.frame = view.bounds
     }
     
     private func configureUI() {
         title = "Profile"
         view.backgroundColor = .systemBackground
     }
     
     
     private func configureCollectionView() {
         view.addSubview(collectionView)
         collectionView.register(
             UICollectionViewCell.self,
             forCellWithReuseIdentifier: "cell"
         )
         
         collectionView.register(
             UICollectionReusableView.self,
             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
             withReuseIdentifier: "UICollectionReusableView"
         )
         
         collectionView.backgroundColor = .systemBackground
         collectionView.delegate = self
         collectionView.dataSource = self
     }
 }





 extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
     
     func numberOfSections(in collectionView: UICollectionView) -> Int {
         //return 1
         return 2
     }
     
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         //return 16
         if section == 0 { return 0 }
         //if section == 1 { return 0 }
         return 7
     }
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
         cell.backgroundColor = .systemBlue
         return cell
     }
     
     func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         
         guard kind == UICollectionView.elementKindSectionHeader else {
             return UICollectionReusableView()
         }
         
         let header = collectionView.dequeueReusableSupplementaryView(
             ofKind: kind,
             withReuseIdentifier: "UICollectionReusableView",
             for: indexPath
         )
         
         
         if indexPath.section == 0 {
             header.backgroundColor = .red
         } else if indexPath.section == 1 {
             header.backgroundColor = .yellow
         }
         return header
     }
 }

 
 */

import UIKit

class FeedViewController: UICollectionViewController {
    

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Feed"
        collectionView.backgroundColor = .white
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
}


// MARK: - UICollectionViewDataSource

extension FeedViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
}
