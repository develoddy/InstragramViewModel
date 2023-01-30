//
//  SheePostViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 30/1/23.
//

import UIKit

protocol DeletePostViewControllerDelegate: AnyObject {
    func deletePostViewControllerDidFinishDeletingPost(_ controller: SheePostViewController)
}

class SheePostViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel = SheePostViewModel()
    
    var sheeView = SheePostView()
    
    var postId = ""
    
    weak var delegate: DeletePostViewControllerDelegate?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
        configureShee()
        bind()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.sheeView.tableView.frame = view.bounds
        self.sheeView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
    
    // MARK: - ViewModel
    
    private func bind() {
        self.viewModel.refreshData = { [weak self] () in
            DispatchQueue.main.async {
                self?.sheeView.tableView.reloadData()
            }
        }
    }
    
    func fetchData() {
        viewModel.fetchData { [weak self] in
            //
        }
    }
    
    // MARK: - Helper
    
    private func configureUI() {
        title = "Shee"
        view.backgroundColor = .blue
    }
    
    private func configureTableView() {
        view.addSubview(sheeView)
        sheeView.tableView.register(SheePostTableViewCell.self, forCellReuseIdentifier: SheePostTableViewCell.identifier)
        sheeView.tableView.separatorStyle = .none
        sheeView.tableView.isScrollEnabled = false
        sheeView.tableView.delegate = self
        sheeView.tableView.dataSource = self
    }
    
    private func configureShee() {
        view.backgroundColor = .systemBackground
        sheetPresentationController.delegate = self
        sheetPresentationController.preferredCornerRadius = 24
        sheetPresentationController.selectedDetentIdentifier = .medium
        sheetPresentationController.prefersGrabberVisible = true
        sheetPresentationController.detents = [
            .medium(),
            //.large(),
        ]
    }
    
    
    // MARK: - Action
}


// MARK: - UISheetPresentationControllerDelegate

extension SheePostViewController: UISheetPresentationControllerDelegate {
    override var sheetPresentationController: UISheetPresentationController {
        presentationController as! UISheetPresentationController
    }
}

// MARK: - UITableViewDataSource
extension SheePostViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SheePostTableViewCell.identifier,
            for: indexPath
        ) as? SheePostTableViewCell else {
            return UITableViewCell()
        }
        
        let data = viewModel.cellForRowAt(indexPath: indexPath)
        cell.viewModel = SheePostTableViewCellViewModel(iconImage: data.iconImage, label: data.label)
        
        cell.backgroundColor = .cyan
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SheePostViewController: UITableViewDelegate {
    
    func currentTopViewController() -> UIViewController {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        var topVC: UIViewController? = keyWindow?.rootViewController
        topVC = topVC?.presentedViewController
        return topVC!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //
        } else if indexPath.section == 1 {
            switch indexPath.item {
            case 0:
                // Edit
                break
            case 1:
                // Delete
                showLoader(true)
                viewModel.deletePost(withPostId: postId) { [weak self] result in
                    guard let stronSelf = self else { return }
                    switch result {
                    case .success(_):
                        stronSelf.showLoader(false)
                        stronSelf.delegate?.deletePostViewControllerDidFinishDeletingPost(stronSelf)
                    case .failure(let err):
                        print(err.localizedDescription)
                    }
                }
            default:
                print("Default..")
            }
        }
    }
}
