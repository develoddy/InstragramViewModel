//
//  CreateStoryCollectionViewCellViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//

import Foundation
import UIKit

struct CreateStoryCollectionViewCellViewModel {
    let user: User
    
    var username: String {
        return user.fullname
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    init(user: User) {
        self.user = user
    }
}
