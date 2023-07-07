//
//  UsersFollowsCollectionViewCellViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 25/1/23.
//

import UIKit

/**enum FollowState {
    case following // indicates the current user is following the other user
    case not_following // indicates the current user is NOT following the other user
}*/

struct UsersFollowsCollectionViewCellViewModel {
    
    var user: User
    
    var cellName : String
    
    var userProfileImageURL: URL? { return URL(string: user.profileImageURL ) }
    
    var username: String { return user.username }
    
    var fullName: String { return user.fullname }
 
    init(user: User, cellName: String ) {
        self.user = user
        self.cellName = cellName
    }

    var followButtonText : String {
        /**if cellName == "followers" {
            return user.isFollwed ? "Delete" : "Follow"
        }
        return user.isFollwed ? "Following" : "Follow"*/
        return cellName == "followers" ? user.isFollwed ? "Delete" : "Follow" : user.isFollwed ? "Following" : "Follow"
    }

    var followButtonBackgroundColor: UIColor {
        return user.isFollwed ? .secondarySystemBackground: .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isFollwed ? .black : .secondarySystemBackground
    }
}
