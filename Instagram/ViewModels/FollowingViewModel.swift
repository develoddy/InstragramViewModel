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
    
    var postService: PostServiceDelegate

    var usersFollowings: [User] = [User]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        followService: FollowServiceDelegate = FollowService(),
        profileService: ProfileServiceDelegate = ProfileService(),
        postService: PostServiceDelegate = PostService()
    ) {
        self.followService = followService
        self.profileService = profileService
        self.postService = postService
    }
    
    // MARK: - Helpers
    
    func fetchFollowings(uid: String, completion: @escaping () -> ()) {
        followService.fetchFollowings(uid: uid) { users in
            self.usersFollowings = users
            completion()
        }
    }
    
    func follow(uid: String, completion: @escaping(Error?)->Void) {
        profileService.follow(uid: uid) { error in
            completion(error)
        }
    }
    
    func unfollow(uid: String, completion: @escaping(Error?)->Void) {
        profileService.unfollow(uid: uid, completion: { error in
            completion(error)
        })
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        profileService.checkIfUserIsFollowed(uid: uid) { isFollowed in
            completion(isFollowed)
        }
    }
    
    func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        postService.updateUserFeedAfterFollowing(user: user, didFollow: didFollow )
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
