//
//  PostCommentPresenter.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import Foundation
import UIKit
import AVFoundation

final class ProfilePresenter {
    
    // MARK: - Properties
    
    static let shared = ProfilePresenter()
    
    // MARK: - Helpers
    
    func startProfile(
        from viewController: UIViewController,
        user: User
    ) {
        let vc = ProfileViewController(user: user)
        vc.title = user.username
        vc.navigationItem.largeTitleDisplayMode = .never
        viewController.navigationController?.pushViewController(vc, animated: true)
    }

}
