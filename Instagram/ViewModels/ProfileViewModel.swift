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
    
    var bindProfileViewModelToController  : (() -> () )?
    
    let profileService: ProfileServiceDelegate
    
    let postService: PostServiceDelegate
    
    var userStats: UserStats?
    
    private var user: User? {
        didSet {
            self.bindProfileViewModelToController?()
        }
    }
    
    var posts: [Post] = [Post]() {
        didSet {
            self.bindProfileViewModelToController?()
        }
    }
    
    
    // MARK: - Init
    
    init(
        profileService: ProfileServiceDelegate = ProfileService(),
        postService: PostServiceDelegate = PostService()
    ) {
        self.profileService = profileService
        self.postService = postService
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
    
    func fetchPosts(uid: String) {
        postService.fetchPosts(forUser: uid) { [weak self] posts in
            self?.posts = posts
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
