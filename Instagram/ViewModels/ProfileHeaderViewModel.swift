//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//

import Foundation
import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    var followButtonText: String {
        // true
        if user.isCurrentUser {
            return "Edit Profile"
        }
        return user.isFollwed ? "Following" : "Follow"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextBackgroundColor: UIColor {
        return user.isCurrentUser ? .black : .white
    }
    
    /*var numberOfFollowers: NSAttributedString {
        return attributedStartText(value: user.stats.followers, button: UIButton(), label: "Followers")
    }
    
    var numberOfFollowings: NSAttributedString {
        return attributedStartText(value: user.stats.following, button: UIButton(), label: "Followings")
    }*/
    
    init(user: User) {
        self.user = user
    }

}
