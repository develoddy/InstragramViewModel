//
//  SettingStorieViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 15/1/23.
//

import UIKit

class SettingStorieViewController: UIViewController {

    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    // MARK: - Helpers
    
    private func configureUI() {
        title = "Storie"
        view.backgroundColor = .systemBlue
    }

    // MARK: - Actions
    

}
