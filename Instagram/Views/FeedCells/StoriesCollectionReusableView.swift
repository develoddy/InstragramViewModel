//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 11/1/23.
//

import UIKit

import SDWebImage

class StoriesCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "StoriesCollectionReusableView"
    
    private let collectionView: UICollectionView
    
    var viewModel = [History]()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 0, height: 0)
        layout.sectionInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        super.init(frame: frame)
        
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        collectionView.register(CreateStoryCollectionViewCell.self, forCellWithReuseIdentifier: CreateStoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    
    // MARK: - Helpers
    func configure(stories: [History])  {
        self.viewModel = stories
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
 
    
    // MARK: - Actions
}

// MARK: - UICollectionViewDataSource

extension StoriesCollectionReusableView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 1 : viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CreateStoryCollectionViewCell.identifier,
                for: indexPath
            ) as? CreateStoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .systemBackground
            return cell
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoryCollectionViewCell.identifier,
                for: indexPath
            ) as? StoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = StoryCollectionViewCellViewModel(history: viewModel[indexPath.row])
            cell.backgroundColor = .systemBackground
            return cell
        default:
            print("DEBUG: error collectionReusable")
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate

extension StoriesCollectionReusableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StoriesCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: 80,
            height: 80
        )
    }
}
