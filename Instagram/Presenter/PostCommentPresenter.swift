//
//  PostCommentPresenter.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 13/1/23.
//

import Foundation
import UIKit
import AVFoundation

final class PostCommentPresenter {
    
    // MARK: - Properties
    
    static let shared = PostCommentPresenter()
    
    // MARK: - Helpers
    
    func startComment(
        from viewController: UIViewController,
        user: String
    ) {
        let vc = CommentsViewController()
        vc.title = "xxComm"
        viewController.navigationController?.pushViewController(vc, animated: true)
    }

}
