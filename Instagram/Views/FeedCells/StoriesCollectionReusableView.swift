//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 11/1/23.
//

import UIKit
import SDWebImage

protocol StoriesCollectionReusableViewDelegate: AnyObject {
    func cell(_ createStoryCell: StoriesCollectionReusableView, didTapActionButtonFor user: User)
}

class StoriesCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "StoriesCollectionReusableView"
    
    weak var delegate: StoriesCollectionReusableViewDelegate?
    
    private let collectionView: UICollectionView
    
    var viewModel = [History]()
    
    var viewModelCurrentUser = [History]()
    
    var user: User?
    
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
        collectionView.register(CreateStoryCollectionViewCell.self, forCellWithReuseIdentifier: CreateStoryCollectionViewCell.identifier)
        collectionView.register(StoryCurrentUserCollectionViewCell.self, forCellWithReuseIdentifier: StoryCurrentUserCollectionViewCell.identifier)
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        
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
    
    func configure(stories: [History], storiesCurrentUser: [History], user: User)  {
        self.viewModel = stories
        self.viewModelCurrentUser = storiesCurrentUser
        self.user = user
        DispatchQueue.main.async{
            self.collectionView.reloadData()
        }
    }
 
    // MARK: - Actions
}

// MARK: - UICollectionViewDataSource

extension StoriesCollectionReusableView: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return 1 } // Create history
        if section == 1 { return viewModelCurrentUser.count > 0 ? 1 : 0 } // Aca tiene que las historias del currentUser
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        switch section {
        /// Create history
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CreateStoryCollectionViewCell.identifier,
                for: indexPath
            ) as? CreateStoryCollectionViewCell else {
                return UICollectionViewCell()
            }
           
            if let user = self.user {
                cell.viewModel = CreateStoryCollectionViewCellViewModel(user: user)
            }
            cell.backgroundColor = .systemBackground
            cell.delegate = self
            return cell
            
        /// Fetch Stories CurrentUser
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoryCurrentUserCollectionViewCell.identifier,
                for: indexPath
            ) as? StoryCurrentUserCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = StoryCollectionViewCellViewModel(
                history: viewModelCurrentUser[ indexPath.row ]
            )
            cell.backgroundColor = .systemBackground
            return cell
            
        /// Fetch Stories
        case 2:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: StoryCollectionViewCell.identifier,
                for: indexPath
            ) as? StoryCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.viewModel = StoryCollectionViewCellViewModel(
                history: viewModel[ indexPath.row ]
            )
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
        collectionView.deselectItem(at: indexPath, animated: true)
        let dd = viewModel[indexPath.row]
        print("DEBUG: obtener datos del story")
        print(dd)
        
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

// MARK: - CreateStoryCollectionViewCellDelegate

extension StoriesCollectionReusableView: CreateStoryCollectionViewCellDelegate {
    
    func cell(_ createStoryCell: CreateStoryCollectionViewCell, didTapActionButtonFor user: User) {
        delegate?.cell(self, didTapActionButtonFor: user)
    }
}
