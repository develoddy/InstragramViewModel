//
//  ViewStoryViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/2/23.
//

import UIKit
import SDWebImage


class SettingViewStoryViewController: UICollectionViewController {

    // MARK: - Properties
        
    var viewModel = [ History ]()
    
    /*let progressView: UIProgressView = {
        let progress = UIProgressView( progressViewStyle: .default )
        progress.tintColor = .gray
        progress.progressTintColor = .systemBlue
        return progress
    }()*/
    
    init( stories: [ History ] ) {
        self.viewModel = stories
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
        configureCollections()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //progressView.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.frame.size.width-20 , height: 20)
        //collectionView.frame = CGRect(x: 10, y: view.height/4, width: view.frame.size.width-20 , height: view.height)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Stories"
        view.backgroundColor = .systemBackground
        //view.addSubview(progressView)
        //progressView.setProgress(0, animated: false)
    }
    
    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.title = "View stories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self, action: #selector(didTapDone)
        )
    }
    
    private func configureCollections() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register( ProgressViewStoriesCollectionViewCell.self, forCellWithReuseIdentifier: ProgressViewStoriesCollectionViewCell.identifier )
        collectionView.register( StoriesViewCollectionViewCell.self, forCellWithReuseIdentifier: StoriesViewCollectionViewCell.identifier )
        
    }
    func startProgress() {
        
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
    }
}

// MARK: - UICollectionViewDataSource

extension SettingViewStoryViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProgressViewStoriesCollectionViewCell.identifier,
                for: indexPath
            ) as? ProgressViewStoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            //cell.configure()
            cell.limit = Int(20)
            
            cell.backgroundColor = .systemBackground
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoriesViewCollectionViewCell.identifier,
                for: indexPath
            ) as? StoriesViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .secondarySystemBackground
            cell.delegate = self
            return cell
        default:
            print("DEBUG: Default..")
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingViewStoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int ) -> CGFloat {
        return 0
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            let width = ( view.frame.width - 2 ) / 2
            return CGSize( width: width, height: 20 )
        }
        let width = ( view.frame.width - 2 )
        return CGSize( width: width, height: view.bounds.size.height/1.5 )
    }
}


// MARK: -  StoriesViewCollectionViewCellDelegate

extension SettingViewStoryViewController: StoriesViewCollectionViewCellDelegate {
    func cell(_ storieViewCell: StoriesViewCollectionViewCell) {
        /*for x in 0..<15 {
            print("DEBUF: conteo is.. \(x)")
            DispatchQueue.main.asyncAfter(deadline: .now()+(Double(x)*0.25), execute: {
                self.progressView.setProgress(Float(x)/14, animated: true)
            })
        }*/
    }
}



/*
class SettingViewStoryViewController: UICollectionViewController {

    // MARK: - Properties
        
    var viewModel = [ History ]()
    
    init( stories: [ History ] ) {
        self.viewModel = stories
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
        configureCollections()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Stories"
        view.backgroundColor = .systemBackground
    }
    
    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.title = "View stories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self, action: #selector(didTapDone)
        )
    }
    
    private func configureCollections() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register( ProgressViewStoriesCollectionViewCell.self, forCellWithReuseIdentifier: ProgressViewStoriesCollectionViewCell.identifier )
        collectionView.register( StoriesViewCollectionViewCell.self, forCellWithReuseIdentifier: StoriesViewCollectionViewCell.identifier )
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
    }
}

// MARK: - UICollectionViewDataSource

extension SettingViewStoryViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 2 : 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = indexPath.section
        switch section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProgressViewStoriesCollectionViewCell.identifier,
                for: indexPath
            ) as? ProgressViewStoriesCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .systemBackground
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StoriesViewCollectionViewCell.identifier,
                for: indexPath
            ) as? StoriesViewCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .secondarySystemBackground
            cell.delegate = self
            return cell
        default:
            print("DEBUG: Default..")
        }
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SettingViewStoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int ) -> CGFloat {
        return 0
    }
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {
        let section = indexPath.section
        if section == 0 {
            let width = ( view.frame.width - 2 ) / 2
            return CGSize( width: width, height: 20 )
        }
        let width = ( view.frame.width - 2 )
        return CGSize( width: width, height: view.bounds.size.height/1.5 )
    }
}


// MARK: -  StoriesViewCollectionViewCellDelegate

extension SettingViewStoryViewController: StoriesViewCollectionViewCellDelegate {
    func cell(_ storieViewCell: StoriesViewCollectionViewCell) {
        
    } 
}*/











/*
class ViewStoryViewController: UIViewController {

    // MARK: - Properties
        
    var stories = [History]()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .lightGray
        /**let tap = UITapGestureRecognizer(target: self, action: #selector(showUserProfile))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)*/
        return imageView
    }()
    
    private lazy var usernameButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("User", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .semibold)
        ///button.addTarget(self, action: #selector(showUserProfile), for: .touchUpInside)
        return button
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.setImage(UIImage(systemName: "multiply"), for: .normal)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor,
            paddingTop: 12,
            paddingLeft: 12
        )
        profileImageView.setDimensions(
            height: 40,
            width: 40
        )
        profileImageView.layer.cornerRadius = 40 / 2
        
        usernameButton.centerY(
            inView: profileImageView,
            leftAnchor: profileImageView.rightAnchor,
            paddingLeft: 8
        )
        
        actionButton.centerY(inView: usernameButton)
        actionButton.anchor(
            right: view.rightAnchor,
            paddingTop: 12,
            paddingRight: 12
        )
        
        imageView.anchor(
            top: profileImageView.bottomAnchor,
            left: view.leftAnchor,
            right: view.rightAnchor,
            paddingTop: 8
        )
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Stories"
        view.backgroundColor = .systemBackground
        
        print("DEBUG: View Story recibe el story array")
        print(self.stories)
        
        view.addSubview(profileImageView)
        view.addSubview(usernameButton)
        view.addSubview(actionButton)
        view.addSubview(imageView)
        
    }
    
    func configureNavigationItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didTapCancel)
        )
        
        navigationItem.title = "View stories"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Listo",
            style: .done,
            target: self, action: #selector(didTapDone)
        )
    }
    
    // MARK: - Actions
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDone() {
    }
}
*/
