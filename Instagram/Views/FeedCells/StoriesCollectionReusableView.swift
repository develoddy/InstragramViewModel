//
//  StoriesCollectionViewCell.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 11/1/23.
//

import UIKit
import SDWebImage

protocol StoriesCollectionReusableViewDelegate: AnyObject {
    //func cell(_ createStoryCell: StoriesCollectionReusableView, didTapActionButtonFor user: User)
    //func cell(_ viewUserStory: StoriesCollectionReusableView, wantsToHistory stories: [History])
    
    func cell(_ viewStory: StoriesCollectionReusableView, wantToStoriesCopy storiesCopy: IGStories, wantToIndexPath indexPath: Int)
    func cell(_ createStoryCell: StoriesCollectionReusableView)
}

class StoriesCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    static let identifier = "StoriesCollectionReusableView"
    
    weak var delegate: StoriesCollectionReusableViewDelegate?
    
    private let collectionView: UICollectionView
    
    var viewModel = [IGStory]()
    
    var getStories: IGStories?
    
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
        
        collectionView.register(IGStoryListCell.self, forCellWithReuseIdentifier: IGStoryListCell.reuseIdentifier)
        collectionView.register(IGAddStoryCell.self, forCellWithReuseIdentifier: IGAddStoryCell.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
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
    func configure(viewModel: [IGStory], getStories: IGStories) {
        self.viewModel = viewModel
        self.getStories = getStories
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Actions
}

// MARK: - UICollectionViewDataSource

extension StoriesCollectionReusableView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count != 0 ? viewModel.count + 1 : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: IGAddStoryCell.reuseIdentifier,
                for: indexPath
            ) as? IGAddStoryCell else {
                fatalError()
            }
            cell.userDetails = ("Your Story","https://avatars2.githubusercontent.com/u/32802714?s=200&v=4")
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: IGStoryListCell.reuseIdentifier,
                for: indexPath
            ) as? IGStoryListCell else {
                fatalError()
            }
            let story = viewModel[indexPath.row-1]
            cell.story = story
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate

extension StoriesCollectionReusableView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            // CREATE HISTORY COMMING SON
            self.delegate?.cell(self)
        } else {
            // PRESENT STORIES
            DispatchQueue.main.async {
                if let stories = self.getStories, let stories_copy = try? stories.copy() {
                    self.delegate?.cell( self, wantToStoriesCopy: stories_copy, wantToIndexPath: indexPath.row-1 )
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StoriesCollectionReusableView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return indexPath.row == 0 ? CGSize( width: 100, height: 100 ) : CGSize( width: 80, height: 100 )
    }
}
































/**
protocol StoriesCollectionReusableViewDelegate: AnyObject {
    func cell(_ createStoryCell: StoriesCollectionReusableView, didTapActionButtonFor user: User)
    func cell(_ viewUserStory: StoriesCollectionReusableView, wantsToHistory stories: [History])
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
    
    func configure( stories: [ History ], storiesCurrentUser: [ History ], user: User )  {
        self.viewModel = stories
        self.viewModelCurrentUser = storiesCurrentUser
        self.user = user
        DispatchQueue.main.async {
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
        if section == 0 { return 1 } // CREATE HISTORY
        if section == 1 { return viewModelCurrentUser.count > 0 ? 1 : 0 } // STORIES CURRENTUSER
        return viewModel.count // OTHER STORIES
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
            
        /// CREATE HISTORY
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
            
        /// STORIES CURRENTUSER
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
            
        /// OTHER STORIES
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
        let section = indexPath.section
        switch section {
        case 1:
            // ZONA DE HISTORY DEL CURRENT USER
            delegate?.cell(self, wantsToHistory: viewModelCurrentUser)
            break
        case 2:
            // ZONA DE STORIES DE OTROS USUARIOS
            break
        default:
            print("DEBUG: Default Other stories")
        }
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
*/
