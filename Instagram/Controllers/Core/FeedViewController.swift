
//
//  FeedViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.


import UIKit
import SDWebImage


enum BrowseSectionType {
    case stories(viewModels: [String]) // 1
    case feeds(viewModels: [Post]) // 2
    
    var title: String {
        switch self {
        case .stories:
            return "New Stories"
        case .feeds:
            return "New Feeds"
        }
    }
}

class FeedViewController: UIViewController {

    // MARK: - Properties
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return FeedViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    var stories:[String] = []
    
    var posts: [Post] = []
    
    var viewModel = FeedViewModel()
    
    var post: Post?
    
    let noFeedview = FeedEmptyLabelView()

    let refresher = UIRefreshControl()
    
    private var sections = [BrowseSectionType]()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        configureNavigationItem()
        setUpNoCommentsView()
        bind()
        fetchPosts()
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noFeedview.frame = CGRect(x: (view.height-150)/2, y: (view.height-150)/2, width: view.width-20, height: 150)
        noFeedview.center = view.center
        collectionView.frame = view.bounds
    }
    
    // MARK: - ViewModels
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            guard let strongSelf = self else { return }
            DispatchQueue.main.async {
                strongSelf.collectionView.reloadData()
            }
        }
    }
    
    private func fetchPosts() {
        if let post = self.post {
            viewModel.fetchPosts(withPostId: post.postId) {
                self.collectionView.refreshControl?.endRefreshing()
                self.updateUI()
                self.checkFollowingBeforeIHadPosts()
                self.checkIfUserLikedPosts()
            }
        } else {
            self.viewModel.fetchFeedPosts {
                self.collectionView.refreshControl?.endRefreshing()
                self.checkFollowingBeforeIHadPosts()
                self.checkIfUserLikedPosts()
            }
        }
    }
    
    private func checkFollowingBeforeIHadPosts() {
        guard let tab = tabBarController as? TabBarViewController  else { return  }
        guard let currentUser = tab.user else { return }
        
        viewModel.fetchFollowings(uid: currentUser.uid ) { [weak self] users in
            guard let strongSelf = self else { return }
            let _ = users.compactMap({ strongSelf.viewModel.updateUserFeedAfterFollowing(user: $0, didFollow: true) })
        }
    }
    
    private func checkIfUserLikedPosts() {
        viewModel.sections.forEach { type in
            switch type {
            case .feeds(let posts):
                posts.forEach { post in
                    viewModel.checkIfUserLikePost(post: post) { didLiked in
                        if let index = self.viewModel.posts.firstIndex(where: { $0.postId == post.postId }) {
                            self.viewModel.posts[index].didLike = didLiked
                        }
                   }
               }
            case .stories(_):
                break
            }
        }
    }
    
    private func checkIfUserLikedPost(post: Post) {
        viewModel.checkIfUserLikePost(post: post) { didLiked in
            self.viewModel.post?.didLike = didLiked
        }
    }
    
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = self.post?.ownerUsername
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(
            FeedCollectionViewCell.self,
            forCellWithReuseIdentifier: FeedCollectionViewCell.identifier
        )
        
        collectionView.register(
            StoriesCollectionViewCell.self,
            forCellWithReuseIdentifier: StoriesCollectionViewCell.identifier
        )
   
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    private func configureNavigationItem() {
        if self.post == nil {
            confireColorNavigation()
            setupRightNavItems()
        }
    }
    
    private func confireColorNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupRightNavItems() {
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
    
    private func setUpNoCommentsView() {
        view.addSubview(noFeedview)
        noFeedview.viewModel = FeedEmptyLabelViewViewModel(
            text: "Todavia no hay publicaciones",
            actionTitle: "Se el primero en publicar."
        )
    }
    
    private func updateUI() {
        if viewModel.sections.isEmpty {
            noFeedview.backgroundColor = .systemBackground
            noFeedview.isHidden = false
            collectionView.isHidden = true
        } else {
            collectionView.reloadData()
            noFeedview.isHidden = true
            collectionView.isHidden = false
        }
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
        viewModel.sections.removeAll()
        fetchPosts()
        collectionView.refreshControl?.endRefreshing()
    }
}


// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {

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
            cell.backgroundColor = .systemBackground
            return cell
            
        case .feeds(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: FeedCollectionViewCell.identifier,
                for: indexPath
            ) as? FeedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.viewModel = FeedCollectionViewCellViewModel(post: viewModel)
            cell.delegate = self
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
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0)
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            // Group
            // Vertical group in horizontal group
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth( 1.0 ),
                    heightDimension: .absolute( 100 ) ), /// 300
                subitem: item,
                count: 1)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth( 0.2 ),
                    heightDimension: .absolute( 100 ) ), /// 300
                subitem: verticalGroup,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            //section.orthogonalScrollingBehavior = .groupPaging
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = supplementaryViews
            return section
            
            
        case 1:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth( 1.0 ),
                    heightDimension: .fractionalHeight( 1.0 )
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets( top: 2, leading: 0, bottom: 2, trailing: 0 )
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth( 1 ),
                    heightDimension: .absolute( 400+200 ) ),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection( group: group )
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
            
        default:
            // Item
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth( 1.0 ),
                    heightDimension: .fractionalHeight( 1.0 )
                )
            )
            
            item.contentInsets = NSDirectionalEdgeInsets( top: 2, leading: 0, bottom: 2, trailing: 0 )
            
            // Group
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .absolute(400+200)),
                subitem: item,
                count: 1)
            
            // Section
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryViews
            
            return section
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem( at: indexPath, animated: true )
    }
}




// MARK: - Delegates buttons

extension FeedViewController: FeedCollectionViewCellDelegate {
    func cell( _ cell: FeedCollectionViewCell, wantsToShowProfileFor uid: String ) {
        UserService.shared.fetchUser( uid: uid ) { result in
            switch result {
            case .success( let user ):
                ProfilePresenter.shared.startProfile(
                    from: self,
                    user: user
                )
            case .failure( let error ):
                print(error.localizedDescription)
            }
        }
    }
    
    func feedCollectionDidTapLike(_ cell: FeedCollectionViewCell, didLike post: Post) {
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let user = tab.user else { return }
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            viewModel.unlikePost( post: post ) { _ in
                cell.likeButton.setImage(
                    UIImage(systemName: "heart"), for: .normal
                )
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            viewModel.likePost( post: post ) { _ in
                cell.likeButton.setImage(
                    UIImage(systemName: "heart.fill"), for: .normal
                )
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                self.viewModel.uploadNotification(
                    toUid: post.ownerUid,
                    fromUser: user,
                    type: .like,
                    post: post
                )
            }
        }
    }
    
    func feedCollectionDidTapComment( _ cell: FeedCollectionViewCell, wantsShowCommentFor post: Post ) {
        PostCommentPresenter.shared.startComment(
            from: self,
            post: post
        )
    }
       
    func feedCollectionDidTapShare(_ user: String) {
        // Share
    }
    
    func feedCollectionDidTapMoreComments(_ user: String) {
        // More Comment
    }
    
    func cell( _ cell: FeedCollectionViewCell, wantsToPost post: Post ) {
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let currentUser = tab.user else { return }
        let vcShee = SheePostViewController()
        vcShee.delegate = self
        vcShee.post = post
        vcShee.currentUser = currentUser
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.present(vcShee, animated: true)
    }
}


//MARK: - SheePostViewControllerDelegate

extension FeedViewController: SheePostViewControllerDelegate {
    func refreshPostViewControllerDidFinishRefreshingPost( _ controller: SheePostViewController ) {
        controller.dismiss( animated: true, completion: nil )
        self.handleRefresh()
    }
    
    func updatePostViewControllerDidFinishDeletingPost( _ controller: SheePostViewController, wantsToUser currentUser: User, wantsToPost post: Post ) {
        controller.dismiss(
            animated: true,
            completion: nil
        )
        let vc = UploadPostViewController()
        vc.type = "update"
        vc.selectedimageName = post.imageURL
        vc.currentUser = currentUser
        vc.post = post
        vc.delegate = self
        let navVC = UINavigationController( rootViewController: vc )
        navVC.modalPresentationStyle = .fullScreen
        self.present(
            navVC,
            animated: true,
            completion: nil
        )
    }

    func deletePostViewControllerDidFinishDeletingPost( _ controller: SheePostViewController ) {
        controller.dismiss(
            animated: true,
            completion: nil
        )
        print("DEBUG: Feed Controller")
        self.navigationController?.popViewController( animated: true )
        guard let tab = tabBarController as? TabBarViewController else { return }
        guard let feedNav = tab.viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? ProfileViewController else { return }
        feed.handleRefresh()
    }
}

// MARK: - UploadPostViewControllerDelegate

extension FeedViewController: UploadPostViewControllerDelegate {
    func updatePostViewControllerDidFinishUploadingPost( _ controller: UploadPostViewController, wantsToPost post: Post ) {
        controller.dismiss( animated: true )
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let feedNav = tab.viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedViewController else { return }
        viewModel.post = post
        feed.handleRefresh()
    }
    
    func uploadPostViewControllerDidFinishUploadingPost( _ controller: UploadPostViewController ) {}
}





/**
class FeedViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel = FeedViewModel()
    
    var post: Post?
    
    private let noFeedview = FeedEmptyLabelView()
    
    private var collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            return FeedViewController.createSectionLayout(section: sectionIndex)
        }
    )
    
    let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        sendPost()
        configureCollectionView()
        configureNavigationItem()
        setUpNoCommentsView()
        bind()
        fetchPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noFeedview.frame = CGRect(x: (view.height-150)/2, y: (view.height-150)/2, width: view.width-20, height: 150)
        noFeedview.center = view.center
        collectionView.frame = view.bounds
    }
    
    // MARK: - ViewModels
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                self?.collectionView.refreshControl = self?.refresher
            }
        }
    }
    
    func sendPost() {
        viewModel.post = self.post
        if let post = viewModel.post {
            checkIfUserLikedPost(post: post)
        }
    }
    
    func fetchPosts() {
        guard self.viewModel.post == nil else { return }
        
        viewModel.fetchFeedPosts { [weak self] in
            self?.collectionView.refreshControl?.endRefreshing()
            self?.updateUI()
            self?.checkFollowingBeforeIHadPosts()
            self?.checkIfUserLikedPosts()
        }
    }
    
    private func checkFollowingBeforeIHadPosts() {
        viewModel.fetchFollowings(uid: viewModel.currentUser(vc: self).uid) { [weak self] users in
            let _ = users.compactMap({ self?.viewModel.updateUserFeedAfterFollowing(user: $0, didFollow: true) })
        }
    }
    
    private func checkIfUserLikedPosts() {
        self.viewModel.posts.forEach { post in
            viewModel.checkIfUserLikePost(post: post) { didLiked in
                if let index = self.viewModel.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.viewModel.posts[index].didLike = didLiked
                }
            }
        }
    }
    
    private func checkIfUserLikedPost(post: Post) {
        viewModel.checkIfUserLikePost(post: post) { didLiked in
            self.viewModel.post?.didLike = didLiked
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Feed"
        view.backgroundColor = .systemBackground
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.register(
            FeedCollectionViewCell.self,
            forCellWithReuseIdentifier: FeedCollectionViewCell.identifier
        )
        
        //collectionView.register(StoriesCollectionViewCell.self, forCellWithReuseIdentifier: StoriesCollectionViewCell.identifier)
        collectionView.register(
            StoriesCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: StoriesCollectionReusableView.identifier
        )
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
    
    private func configureNavigationItem() {
        if viewModel.post == nil {
            confireColorNavigation()
            setupRightNavItems()
        }
    }
    
    private func confireColorNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupRightNavItems() {
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
    
    private func setUpNoCommentsView() {
        view.addSubview(noFeedview)
        noFeedview.viewModel = FeedEmptyLabelViewViewModel(
            text: "Todavia no hay publicaciones",
            actionTitle: "Se el primero en publicar."
        )
    }
    
    private func updateUI() {
        if viewModel.posts.isEmpty {
            noFeedview.backgroundColor = .systemBackground
            noFeedview.isHidden = false
            collectionView.isHidden = true
        } else {
            collectionView.reloadData()
            noFeedview.isHidden = true
            collectionView.isHidden = false
        }
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
        self.viewModel.posts.removeAll()
        fetchPosts()
        
        if viewModel.post != nil {
            self.collectionView.refreshControl?.endRefreshing()
            sendPost()
        }
    }
}


// MARK: - UICollectionViewDataSource

extension FeedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.post == nil ? viewModel.numberOfRowsInSection(section: section) : 1
    }
   
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FeedCollectionViewCell.identifier,
            for: indexPath
        ) as? FeedCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let post = viewModel.post {
            cell.viewModel = FeedCollectionViewCellViewModel(post: post)
            cell.delegate = self
            return cell
        } else {
            cell.viewModel = FeedCollectionViewCellViewModel(post: viewModel.cellForRowAt(indexPath: indexPath))
            cell.delegate = self
        }
        
        cell.backgroundColor = .systemBackground
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

// MARK: - UICollectionViewDelegate

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: StoriesCollectionReusableView.identifier,
            for: indexPath
        ) as? StoriesCollectionReusableView else {
            return UICollectionReusableView()
        }
        header.backgroundColor = .blue
        return header
    }
}


// MARK: - Delegates buttons

extension FeedViewController: FeedCollectionViewCellDelegate {
    func cell(_ cell: FeedCollectionViewCell, wantsToShowProfileFor uid: String) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                ProfilePresenter.shared.startProfile(from: self, user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func feedCollectionDidTapLike(_ cell: FeedCollectionViewCell, didLike post: Post) {
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let user = tab.user else { return }
        
        cell.viewModel?.post.didLike.toggle()
        
        if post.didLike {
            viewModel.unlikePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
            viewModel.likePost(post: post) { _ in
                cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
                
                self.viewModel.uploadNotification(
                    toUid: post.ownerUid,
                    fromUser: user,
                    type: .like,
                    post: post
                )
            }
        }
    }
    
    func feedCollectionDidTapComment(
        _ cell: FeedCollectionViewCell,
        wantsShowCommentFor post: Post
    ) {
        PostCommentPresenter.shared.startComment(from: self, post: post)
    }
       
    func feedCollectionDidTapShare(_ user: String) {
        // Share
    }
    
    func feedCollectionDidTapMoreComments(_ user: String) {
        // More Comment
    }
    
    func cell(
        _ cell: FeedCollectionViewCell,
        wantsToPost post: Post
    ) {
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let currentUser = tab.user else { return }
        let vcShee = SheePostViewController()
        vcShee.delegate = self
        vcShee.post = post
        vcShee.currentUser = currentUser
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.present(vcShee, animated: true)
    }
}

//MARK: - SheePostViewControllerDelegate

extension FeedViewController: SheePostViewControllerDelegate {
    func refreshPostViewControllerDidFinishRefreshingPost(_ controller: SheePostViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.handleRefresh()
    }
    
    func updatePostViewControllerDidFinishDeletingPost(
        _ controller: SheePostViewController,
        wantsToUser currentUser: User,
        wantsToPost post: Post
    ) {
        controller.dismiss(animated: true, completion: nil)
        let vc = UploadPostViewController()
        vc.type = "update"
        vc.selectedimageName = post.imageURL
        vc.currentUser = currentUser
        vc.post = post
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }

    func deletePostViewControllerDidFinishDeletingPost(_ controller: SheePostViewController) {
        controller.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let feedNav = tab.viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? ProfileViewController else { return }
        feed.handleRefresh()
    }
}


// MARK: - UploadPostViewControllerDelegate

extension FeedViewController: UploadPostViewControllerDelegate {
    func updatePostViewControllerDidFinishUploadingPost(
        _ controller: UploadPostViewController,
        wantsToPost post: Post
    ) {
        controller.dismiss(animated: true)
        guard let tab = tabBarController as? TabBarViewController  else { return }
        guard let feedNav = tab.viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedViewController else { return }
        viewModel.post = post
        feed.handleRefresh()
    }
    
    func uploadPostViewControllerDidFinishUploadingPost(_ controller: UploadPostViewController) {}
}
*/
