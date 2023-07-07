//
//  FollowSettingPresenter.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 25/1/23.
//

import Foundation
import UIKit
import AVFoundation

final class FollowSettingPresenter {
    
    // MARK: - Properties
    
    static let shared = FollowSettingPresenter()
    
    // MARK: - Helpers
    
    func startFollwSetting(
        from viewController: UIViewController,
        uid: String,
        vcName: String
    ) {
        let vc = FollowSettingViewController(uid: uid, vcName: vcName)
        vc.navigationItem.largeTitleDisplayMode = .never
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
