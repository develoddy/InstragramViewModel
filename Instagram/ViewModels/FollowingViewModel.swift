//
//  FollowingViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 25/1/23.
//

import Foundation
import Firebase

class FollowingViewModel {
    
    // MARK: - Porperties
    
    var refreshData: ( () -> () )?

    var followService: FollowServiceDelegate
    
    var profileService: ProfileServiceDelegate

    var usersFollowings: [User] = [User]() {
        didSet {
            self.refreshData?()
        }
    }
  
    
    // MARK: - Init
    
    init(
        followService: FollowServiceDelegate = FollowService(),
        profileService: ProfileServiceDelegate = ProfileService()
    ) {
        self.followService = followService
        self.profileService = profileService
    }
    
    // MARK: - Helpers
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        profileService.checkIfUserIsFollowed(uid: uid) { isFollowed in
            completion(isFollowed)
        }
    }
   
    
    func numberOfSections() -> Int {
        return usersFollowings.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if usersFollowings.count != 0 {
            return usersFollowings.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> User {
        return usersFollowings[indexPath.row]
    }

}

