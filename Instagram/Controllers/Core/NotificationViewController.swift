//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit

/**struct NotificationSection {
    let title: String
    let categorys: [NotificationCategory]
}*/

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
            // Refresh
            print("DEBUG: Notification \(String(describing: self?.viewModel.notifications)) ")
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
    }
    
    
    // MARK: - Actions
}


//MARK: - UITableViewDataSource

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
        return cell
        
    }
    
    /**func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }*/
}
