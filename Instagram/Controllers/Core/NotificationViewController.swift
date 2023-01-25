//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit

class NotificationViewController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = NotificationViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(NotificationsDefaultTableViewCell.self, forCellReuseIdentifier: NotificationsDefaultTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        bind()
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // MARK: - ViewModels
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func fetchNotifications() {
        self.viewModel.fetchNotifications { [weak self] in
            ///print("DEBUG: Notification \(String(describing: self?.viewModel.notifications)) ")
            self?.checkIfUserIsFollowed()
        }
    }
    
    private func checkIfUserIsFollowed() {
        viewModel.notifications.forEach { notification in
            guard notification.type == .follow else { return }
            viewModel.checkIfUserIsFollowed(uid: notification.uid) { isFollowed in
                if let index = self.viewModel.notifications.firstIndex(where: { $0.id == notification.id }) {
                    self.viewModel.notifications[index].userIsFollowed = isFollowed
                }
            }
        }
    }

    // MARK: - Helpers
    
    private func configureUI() {
        title = "Notification"
        view.backgroundColor = .orange
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
        
    }
    
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        viewModel.notifications.removeAll()
        fetchNotifications()
        refresher.endRefreshing()
    }
}


//MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NotificationsDefaultTableViewCell.identifier,
            for: indexPath
        ) as? NotificationsDefaultTableViewCell else {
            return UITableViewCell()
        }
        
        let notification = self.viewModel.cellForRowAt(indexPath: indexPath)
        cell.viewModel = NotificationsDefaultTableViewCellViewModel(notification: notification)
        cell.delegate = self
        return cell
    }
}

//MARK: - UITableViewDelegate

extension NotificationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showLoader(true)
        UserService.shared.fetchUser(uid: viewModel.cellForRowAt(indexPath: indexPath).uid) { result in
            self.showLoader(false)
            switch result {
            case .success(let user):
                ProfilePresenter.shared.startProfile(from: self, user: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

//MARK: - NotificationsDefaultTableViewCellDelegate

extension NotificationViewController: NotificationsDefaultTableViewCellDelegate {
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsToFollow uid: String) {
        showLoader(true)
        viewModel.follow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsTounFollow uid: String) {
        showLoader(true)
        viewModel.unfollow(uid: uid) { _ in
            self.showLoader(false)
            cell.viewModel?.notification.userIsFollowed.toggle()
        }
    }
    
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsToViewPost postId: String) {
        showLoader(true)
        viewModel.fetchPosts(withPostId: postId) { [weak self] in
            guard let stronSelf = self else { return }
            stronSelf.showLoader(false)
            guard let post = stronSelf.viewModel.post else { return }
            FeedPresenter.shared.startFeed(from: stronSelf, post: post)
        }
    }
}
