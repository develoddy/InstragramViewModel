//
//  SearchResultsViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 10/1/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ result: User)
}

class SearchResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    // MARK: - Properties
    
    private var users: [User] = []
    
    weak var delegate: SearchResultsViewControllerDelegate?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        return tableView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
        
    
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Search Result"
        view.backgroundColor = .systemBackground
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func update(with results: [User]) {
        self.users = results
        tableView.reloadData()
        tableView.isHidden = results.isEmpty
    }
    
    
    // MARK: - Actions
    
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //users.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SearchResultDefaultTableViewCell.identifier,
            for: indexPath
        ) as? SearchResultDefaultTableViewCell else {
            return UITableViewCell()
        }
        let user = users[indexPath.row]
        let viewModel = SearchResultDefaultTableViewCellViewModel(username: user.username, fullname: user.fullname, imageURL: URL(string: user.profileImageURL))
        cell.configure(with: viewModel)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //let result = sections[indexPath.section].results[indexPath.row]
        //delegate?.didTapResult(result)
        //let result = users[indexPath.row]
        //print("debung select: ")
        //print(result)
        //navigationController?.pushViewController(ProfileViewController(user: users[indexPath.row]), animated: true)
        let user = users[indexPath.row]
        delegate?.didTapResult(user)
    }
}
