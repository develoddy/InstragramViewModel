//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 16/1/23.
//

import Foundation
import Firebase

class FollowSettingViewModel {
    
    // MARK: - Porperties
    
    //var bindProfileViewModelToController  : (() -> () )?
    var refreshData: ( () -> () )?
    
    var profileService: ProfileServiceDelegate
    
    var userStats: UserStats? {
        didSet {
            self.refreshData?()
        }
    }

    /**var users: [User] = [User]() {
        didSet {
            self.refreshData?()
        }
    }*/

    
    
    // MARK: - Lifecycle
    
    init(
        profileService: ProfileServiceDelegate = ProfileService()
    ) {
        self.profileService = profileService
    }
    
    // MARK: - Helpers

    func fetchUserStats(uid: String, completion: @escaping () -> () ) {
        profileService.fetchUserStats(uid: uid) { stats in
            self.userStats = stats
            completion()
        }
    }

    /**func updatePropertiStats(stats: UserStats) {
        self.user?.stats = stats
    }*/
    
    

}

