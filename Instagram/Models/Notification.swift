//
//  Notifications.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import Firebase

enum NotificationType: Int {
    case like
    case follow
    case comment
    
    var notificationMessage: String {
        switch self {
        case .like: return " liked your post."
        case .follow: return " started following you."
        case .comment: return " commented on your post."
        }
    }
}

struct Notification {
    let uid: String
    let postImageURL: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let id: String
    let userProfileImageURL: String?
    let username: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.postImageURL = dictionary["postImageURL"] as? String ?? ""
        self.postId = dictionary["postId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.type = NotificationType(rawValue: dictionary["type"] as? Int ?? 0) ?? .like
        self.id = dictionary["id"] as? String ?? ""
        self.userProfileImageURL = dictionary["userProfileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
    }
}
