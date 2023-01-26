//
//  FollowingViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 25/1/23.
//

import Foundation
import Firebase

class FollowerViewModel {
    
    // MARK: - Porperties
    
    var refreshData: ( () -> () )?

    var followService: FollowServiceDelegate
    
    var profileService: ProfileServiceDelegate
    
    var postService: PostServiceDelegate

    var usersFollowers: [User] = [User]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Init
    
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
    
    func fetchFollowers(uid: String, completion: @escaping () -> ()) {
        followService.fetchFollowers(uid: uid) { users in
            print(users)
            self.usersFollowers = users
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
        return usersFollowers.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if usersFollowers.count != 0 {
            return usersFollowers.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> User {
        return usersFollowers[indexPath.row]
    }
}
