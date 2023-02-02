//
//  EditProfileViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 1/2/23.
//

import UIKit
import SDWebImage

protocol EditProfileViewControllerDelegate: AnyObject {
    func updateEditProfileViewControllerDidFinishUpdateUser(_ controller: EditProfileViewController)
}


class EditProfileViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel = EditProfileViewModel()
    
    weak var delegate: EditProfileViewControllerDelegate?
    
    var uid = ""
    
    var label = ""
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        return tableView
    }()
    
    let refresher = UIRefreshControl()
    
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBarButton()
        bind()
        fetchData()
        configureTableView()
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
    
    private func fetchData() {
        showLoader(true)
        viewModel.fetchData(uid: self.uid) {
            self.showLoader(false)
            self.tableView.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        navigationItem.title = "Editar perfil"
        view.backgroundColor = .systemBlue
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(FormEditProfileTableViewCell.self, forCellReuseIdentifier: FormEditProfileTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeaderView()
        
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refresher
    }
    
    private func configureBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Listo", style: .done, target: self, action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
    }
    
    // MARK: - Actions
    
    @objc func didTapProfilePhotoButton() {
        print("DEBUG: Did Tap Cambiar image de perfil..")
    }
    
    @objc func didTapSave() {
        // Save info to database
        delegate?.updateEditProfileViewControllerDidFinishUpdateUser(self)
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleRefresh() {
        self.viewModel.models.removeAll()
        fetchData()
    }
}

// MARK: - UITableViewDataSource

extension EditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: FormEditProfileTableViewCell.identifier, for: indexPath
        ) as? FormEditProfileTableViewCell else {
            return UITableViewCell()
        }
        let model = viewModel.cellForRowAt(indexPath: indexPath)
        cell.viewModel = FormEditProfileTableViewCellViewModel(label: model.label, placeHolder: model.placeHolder, value: model.value)
        cell.backgroundColor = .systemBackground
        cell.selectionStyle = .none
        return cell
    }
    
    private func createTableHeaderView() -> UIView {
        let header = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: view.width,
                height: view.height/4
            ).integral
        )
        
        let size = header.height/2
        let profilePhotoButton = UIButton(
            frame: CGRect(
                x: (view.width-size)/2,
                y: (header.height-size)/2,
                width: size,
                height: size
            )
        )
        header.addSubview(profilePhotoButton)
        
        let label = UILabel(
            frame: CGRect(
                x: 10,
                y: profilePhotoButton.bottom+5,
                width: view.width-20,
                height: 20
            )
        )
        label.backgroundColor = .systemBackground
        label.text = "Cambiar foto de perfil"
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .systemBlue
        label.textAlignment = .center
        header.addSubview(label)
        
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        
        UserService.shared.fetchUser(uid: self.uid) { result in
            switch result {
            case .success(let user):
                profilePhotoButton.sd_setImage(with: URL(string: user.profileImageURL), for: .normal)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        return header
    }
}

// MARK: - UITableViewDelegate

extension EditProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = viewModel.cellForRowAt(indexPath: indexPath)
        let vc = EditTextFieldViewController()
        vc.model = model
        vc.delegate = self
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: - EditTextFieldViewControllerDelegate

extension EditProfileViewController: EditTextFieldViewControllerDelegate {
    func inputView(controller: EditTextFieldViewController, wantsToUploadLabel label: String, wantsToUploadValue value: String) {
        
        switch label {
        case "Name": self.label = "lastname"
        case "Username": self.label = "username"
        default:print("DEBUG: Labels error..")
        }
        
        controller.navigationController?.popViewController(animated: true)
        self.handleRefresh()
        
        showLoader(true)
        UserService.shared.updateUserValue(
            uid: uid,
            label: self.label,
            value: value
        ) { [weak self] error in
            guard let strongSelf = self else { return }
            strongSelf.showLoader(false)
            if let error = error {
                print("DEBUG: Failed to update value user: \(error.localizedDescription)")
                return
            }
        }
    }
}
