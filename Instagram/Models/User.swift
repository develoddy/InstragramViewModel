//
//  User.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//

import Foundation
import Firebase

enum UserFollowType: Int {
    case follow
    case delete
    
    var userFollowMessage: String {
        switch self {
        case .follow: return " started following you."
        case .delete: return " liked your post."
        }
    }
}

struct User {
    let email: String
    let fullname: String
    let profileImageURL: String
    var username: String
    let uid: String
    let type: UserFollowType
    
    var isFollwed = false
    
    var stats: UserStats!
    
    var isCurrentUser: Bool {
        // Se compueba si el uid es igual al uid que está logueado en la App
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["lastname"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.stats = UserStats(followers: 0, following: 0, posts: 0)
        self.type = UserFollowType(rawValue: dictionary["type"] as? Int ?? 0) ?? .follow
    }
}

struct UserStats {
    let followers: Int
    let following: Int
    let posts: Int
}
