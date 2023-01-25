//
//  FollowSettingViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import UIKit

class FollowSettingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let followersVC = FollowersViewController()
    private let followingVC = FollowingViewController()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    private let toggleView = FollowToggleView()
    
    var users = [User]()
    
    var vcName = ""
    
    // MARK: - Lifecycle
    
    init(users:[User], vcName: String) {
        self.users = users
        self.vcName = vcName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionViews()
        configureToggleView()
        addChildren()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top+20,
            width: view.width,
            height: view.height-view.safeAreaInsets.top-view.safeAreaInsets.bottom-55
        )
        
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 55
        )
        
        /*
         scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
         updateBarButtons()
         */
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "lujandev"
        view.backgroundColor = .systemBackground
    }
    
    private func configureToggleView() {
        view.addSubview(toggleView)
        toggleView.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: 200,
            height: 55
        )
        toggleView.delegate = self
    }
    
    private func configureCollectionViews() {
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(
            width: view.width*2,
            height: scrollView.height
        )
        scrollView.delegate = self
    }
    
    private func updateBarButtons() {
        switch toggleView.state {
        case .playlist:
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
        case .album:
            navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func addChildren() {
        addChild(followersVC)
        scrollView.addSubview(followersVC.view)
        followersVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: scrollView.height)
        followersVC.didMove(toParent: self)
        
        addChild(followingVC)
        scrollView.addSubview(followingVC.view)
        followingVC.view.frame = CGRect(x: view.width, y: 0, width: scrollView.width, height: scrollView.height)
        followingVC.didMove(toParent: self)
        
        if self.vcName == "followers" {
            scrollView.setContentOffset(.zero, animated: true)
            followersVC.usersFollowers(users: self.users)
            updateBarButtons()
        } else if self.vcName == "followings" {
            followingVC.usersFollowings(users: self.users)
            scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
            updateBarButtons()
        }
    }
    
    // MARK: - Actions
    
    @objc private func didTapAdd() {
        //followersVC.showCreatePlaylistAlert()
    }

}

// MARK: - UIScrollViewDelegate

extension FollowSettingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x >= (view.width-100) {
            toggleView.update(for: .album)
            updateBarButtons()
        } else {
            toggleView.update(for: .playlist)
            updateBarButtons()
        }
    }
}

// MARK: - FollowToggleViewDelegate

extension FollowSettingViewController: FollowToggleViewDelegate {
    func followToggleViewDidTapPlaylists(_ toggleView: FollowToggleView) {
        scrollView.setContentOffset(.zero, animated: true)
        updateBarButtons()
    }
    
    func followToggleViewDidTapAlbums(_ toggleView: FollowToggleView) {
        scrollView.setContentOffset(CGPoint(x: view.width, y: 0), animated: true)
        updateBarButtons()
    }
}
