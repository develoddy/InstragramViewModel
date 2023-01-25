//
//  UsersFollowsCollectionViewCellViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 25/1/23.
//

import UIKit

enum FollowState {
    case following // indicates the current user is following the other user
    case not_following // indicates the current user is NOT following the other user
}

/**struct UserRelationship {
    let username: String
    let namm: String
    let type: FollowState
}*/

struct UsersFollowsCollectionViewCellViewModel {
    
    var user: User
    
    var userProfileImageURL: URL? { return URL(string: user.profileImageURL ) }
    
    var username: String { return user.username }
    
    var fullName: String { return user.fullname }
 
    init(user: User) {
        self.user = user
    }
    
    var followButtonText : String {
        return user.isFollwed ? "Following" : "Follow11"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isFollwed ? .lightGray: .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isFollwed ? .black : .lightGray
    }
}
