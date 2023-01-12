//
//  NotificationViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit

struct NotificationSection {
    let title: String
    let categorys: [NotificationCategory]
}

class NotificationViewController: UIViewController {
    
    // MARK: - Properties
    private var sections: [NotificationSection] = []
    
    private var categorys =  [Notifications]()
    
    private var previous = [Notifications]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(NotificationsDefaultTableViewCell.self, forCellReuseIdentifier: NotificationsDefaultTableViewCell.identifier)
        return tableView
    }()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    // MARK: - Api
    func fetchData() {
        let weekItem1 = Notifications(
            fullname: "userPrueba1",
            profileImageURL: "https://firebasestorage.googleapis.com/v0/b/instagram-e7380.appspot.com/o/eddy.jpg?alt=media&token=32b063dd-2742-459a-89dd-35f7999d8743",
            username: "userName1",
            uid: "idXXXXXXXX1"
        )
        
        let weekItem2 = Notifications(
            fullname: "userPrueba2",
            profileImageURL: "https://firebasestorage.googleapis.com/v0/b/instagram-e7380.appspot.com/o/eddy.jpg?alt=media&token=32b063dd-2742-459a-89dd-35f7999d8743",
            username: "userName2",
            uid: "idXXXXXXXX2"
        )
        categorys.append(weekItem1)
        categorys.append(weekItem2)
        
        let previous01 = Notifications(
            fullname: "userPrueba1",
            profileImageURL: "https://firebasestorage.googleapis.com/v0/b/instagram-e7380.appspot.com/o/eddy.jpg?alt=media&token=32b063dd-2742-459a-89dd-35f7999d8743",
            username: "userName1",
            uid: "idXXXXXXXX1"
        )
        previous.append(previous01)
        
        
        let week = NotificationsItemsResponse(items: categorys)
        let previou = previousItemsResponse(items: previous)
        
        let result = NotificationsResponse(notifications: week, previous: previou)
        
        
        var searchResult: [NotificationCategory] = []
        searchResult.append(contentsOf: result.notifications.items.compactMap({ .week(model: $0 ) }) )
        searchResult.append(contentsOf: result.previous.items.compactMap({ .previous(model: $0) }))
        
        self.update(with: searchResult)
        
    }
    
    func update(with results: [NotificationCategory]) {
        let week = results.filter({
            switch $0 {
            case .week: return true
            default: return false
            }
        })
        
        let previus = results.filter({
            switch $0 {
            case .previous: return true
            default: return false
            }
        })
        
        self.sections = [
            NotificationSection(title: "Nuevas", categorys: week),
            NotificationSection(title: "Anterioes", categorys: previus),
        ]
        tableView.reloadData()
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

//MARK: - TableView
extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].categorys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let result = sections[indexPath.section].categorys[indexPath.row]
        switch result {
        case .week(let week):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsDefaultTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsDefaultTableViewCell else {
                return UITableViewCell()
            }
            let viewModel = NotificationsDefaultTableViewCellViewModel(
                username: week.username,
                imageURL: URL(string: week.profileImageURL)
            )
            cell.configure(with: viewModel)
            return cell
            
        case .previous(let previous):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: NotificationsDefaultTableViewCell.identifier,
                for: indexPath
            ) as? NotificationsDefaultTableViewCell else {
                return UITableViewCell()
            }
            
            let viewModel = NotificationsDefaultTableViewCellViewModel(
                username: previous.username,
                imageURL: URL(string: previous.profileImageURL)
            )
            cell.configure(with: viewModel)
            return cell
        }
    }
    
  
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }
}
