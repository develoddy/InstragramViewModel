//
//  EditProfilePresenter.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 1/2/23.
//

import UIKit

final class EditProfilePresenter {
    
    // MARK: - Properties
    
    static let shared = EditProfilePresenter()
    
    // MARK: - Helpers
    
    func startEditProfile(
        from viewController: UIViewController,
        user: User
    ) {
        let vc = EditProfileViewController()
        vc.uid = user.uid
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        viewController.present(navVC, animated: true, completion: nil)
    }
}
