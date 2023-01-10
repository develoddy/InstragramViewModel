//
//  ProfileHeaderViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullname: String {
        return user.fullname
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    init(user: User) {
        self.user = user
    }
}
