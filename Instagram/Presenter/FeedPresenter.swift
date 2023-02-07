//
//  FeedPresenter.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 24/1/23.
//


import Foundation
import UIKit
import AVFoundation

final class FeedPresenter {
    
    // MARK: - Properties
    
    static let shared = FeedPresenter()
    
    // MARK: - Helpers

    func startFeed(
        from viewController: UIViewController,
        post: Post,
        indexPath: IndexPath? = nil
    ) {
        let vc = FeedViewController()
        vc.post = post
        vc.navigationItem.largeTitleDisplayMode = .never
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
}
