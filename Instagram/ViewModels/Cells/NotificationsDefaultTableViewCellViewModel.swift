//
//  NotificationsDefaultTableViewCellViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 24/1/23.
//

import UIKit

struct NotificationsDefaultTableViewCellViewModel {
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageURL: URL? { return URL(string: notification.postImageURL ?? "") }
    
    var profileImageURL: URL? { return URL(string: notification.userProfileImageURL ?? "") }
    
    var notificationMessage: NSAttributedString {
        let username = notification.username
        let message = notification.type.notificationMessage
        
        let attributedTex = NSMutableAttributedString(string: username, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .bold) ])
        
        attributedTex.append(NSAttributedString(string: message, attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular) ]))
        
        attributedTex.append(NSAttributedString(string: " 2m", attributes: [.font: UIFont.systemFont(ofSize: 12, weight: .regular), .foregroundColor: UIColor.lightGray ]))
        
        return attributedTex
    }
    
    var shouldHidePostImage: Bool { return self.notification.type == .follow }
    
    var followButtonText : String {
        return self.notification.userIsFollowed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return notification.userIsFollowed ? .white: .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return notification.userIsFollowed ? .black : .white
    }
}