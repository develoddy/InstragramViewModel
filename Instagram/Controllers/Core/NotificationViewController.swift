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
    
    let noNotificationview = FeedEmptyLabelView()
    
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
        setUpNoNotificationView()
        bind()
        fetchNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noNotificationview.frame = CGRect(x: (view.height-150)/2, y: (view.height-150)/2, width: view.width-20, height: 150)
        noNotificationview.center = view.center
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
            self?.tableView.refreshControl?.endRefreshing()
            self?.updateUI()
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
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    private func setUpNoNotificationView() {
        view.addSubview(noNotificationview)
        noNotificationview.viewModel = FeedEmptyLabelViewViewModel(
            text: "Todavia no hay notificaciones.",
            actionTitle: ""
        )
    }
    
    private func updateUI() {
        if viewModel.notifications.isEmpty {
            noNotificationview.backgroundColor = .systemBackground
            noNotificationview.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noNotificationview.isHidden = true
            tableView.isHidden = false
        }
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
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsTounFollow uid: String) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                self.showLoader(true)
                self.viewModel.unfollow(uid: uid) { _ in
                    self.showLoader(false)
                    cell.viewModel?.notification.userIsFollowed.toggle()
                    self.viewModel.updateUserFeedAfterFollowing(
                        user: user,
                        didFollow: false
                    )
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func cell(_ cell: NotificationsDefaultTableViewCell, wantsToFollow uid: String) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                self.showLoader(true)
                self.viewModel.follow(uid: uid) { _ in
                    self.showLoader(false)
                    cell.viewModel?.notification.userIsFollowed.toggle()
                    self.viewModel.updateUserFeedAfterFollowing(
                        user: user,
                        didFollow: true
                    )
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
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
