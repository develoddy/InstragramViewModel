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
    
    //var bindProfileViewModelToController  : (() -> () )?
    var refreshData: ( () -> () )?
    
    var profileService: ProfileServiceDelegate
    
    var postService: PostServiceDelegate
    
    var notificationService: NotificationServiceDelegate
    
    var followService: FollowServiceDelegate
    
    var userStats: UserStats?
    
    var user: User? {
        didSet {
            self.refreshData?()
        }
    }
    
    var users: [User] = [User]() {
        didSet {
            self.refreshData?()
        }
    }
    
    var posts: [Post] = [Post]() {
        didSet {
            self.refreshData?()
        }
    }
    
    
    // MARK: - Init
    
    init(
        profileService: ProfileServiceDelegate = ProfileService(),
        postService: PostServiceDelegate = PostService(),
        notificationService: NotificationServiceDelegate = NotificationService(),
        followService: FollowServiceDelegate = FollowService()
    ) {
        self.profileService = profileService
        self.postService = postService
        self.notificationService = notificationService
        self.followService = followService
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
    
    func fetchFollowings(uid: String, completion: @escaping () -> ()) {
        followService.fetchFollowings(uid: uid) { users in
            self.users = users
            completion()
        }
    }
    
    func fetchFollowers(uid: String, completion: @escaping () -> ()) {
        followService.fetchFollowers(uid: uid) { users in
            self.users = users
            completion()
        }
    }
    
    func fetchPosts(uid: String) {
        postService.fetchPosts(forUser: uid) { [weak self] posts in
            self?.posts = posts
        }
    }
    
    func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        notificationService.uploadNotification(
            toUid: uid,
            fromUser: fromUser,
            type: type,
            post: post)
    }
    
    func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        postService.updateUserFeedAfterFollowing(user: user, didFollow: didFollow )
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
        
    func fetchUser() -> User? {
        return self.user
    }
    
    
    func numberOfSections() -> Int {
        return posts.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if posts.count != 0 {
            return posts.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Post {
        return posts[indexPath.row]
    }

}
