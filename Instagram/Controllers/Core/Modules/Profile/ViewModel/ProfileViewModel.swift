//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 16/1/23.
//

import Foundation
import Firebase

class ProfileViewModel {
    
    // MARK: - Porperties
    let profileService: ProfileServiceDelegate
    
    private var user: User? {
        didSet {
            self.bindProfileViewModelToController?()
        }
    }
    
    var userStats: UserStats?
    
    var bindProfileViewModelToController  : (() -> () )?
    
    // MARK: - Init
    init(profileService: ProfileServiceDelegate = ProfileService()) {
        self.profileService = profileService
    }
    
    // MARK: - Helpers
    
    func updatePropertiesUser(user: User) {
        self.user = user
    }
    
    func checkIfUserIsFollowed(completion: @escaping(Bool) -> Void) {
        guard let uid = self.user?.uid else { return }
        profileService.checkIfUserIsFollowed(uid: uid) { isFollowed in
            completion(isFollowed)
        }
    }

    func follow(completion: @escaping(Error?)->Void) {
        guard let uid = self.user?.uid else { return }
        profileService.follow(uid: uid) { error in
            completion(error)
        }
    }
    
    func unfollow(completion: @escaping(Error?)->Void) {
        guard let uid = self.user?.uid else { return }
        profileService.unfollow(uid: uid, completion: { error in
            completion(error)
        })
    }
    
    func fetchUserStats(uid: String, completion: @escaping (UserStats) ->Void ) {
        profileService.fetchUserStats(uid: uid) { stats in
            completion(stats)
        }
    }
    
    func updatePropertiStats(stats: UserStats) {
        self.user?.stats = stats
    }
    
    func updatePropertiesIsFollwed(isFollowed: Bool) {
        self.user?.isFollwed = isFollowed
    }
    
    func getUID() -> String {
        guard let uid = self.user?.uid else { return "" }
        return uid
    }
    
    func getUsername() -> String {
        return self.user?.username ?? "-"
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return 10
    }
    
    func fetchUser() -> User? {
        return self.user
    }
}
