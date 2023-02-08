//
//  HomeViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import Foundation
import UIKit

class FeedViewModel {
    
    // MARK: - Properties
    
    let postService: PostServiceDelegate
    
    let historyService: HistoryServiceDelegate
    
    let notificationService: NotificationServiceDelegate
    
    var followService: FollowServiceDelegate
    
    var refreshData: ( () -> () )?
    
    var post: Post? {
        didSet {
            refreshData?()
        }
    }
    
    var stories: [ History ] = [ History ]() {
        didSet {
            refreshData?()
        }
    }
    
    var posts: [ Post ] = [ Post ]() {
        didSet {
            refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        postService: PostServiceDelegate = PostService(),
        historyService: HistoryServiceDelegate = HistoryService(),
        notificationService: NotificationServiceDelegate = NotificationService(),
        followService: FollowServiceDelegate = FollowService()
    ) {
        self.postService = postService
        self.notificationService = notificationService
        self.followService = followService
        self.historyService = historyService
    }
    
    // MARK: - Helpers
    
    func currentUser(vc: UIViewController) -> User {
        guard let tab = vc.tabBarController as? TabBarViewController  else { fatalError("not data currentUser")  }
        guard let user = tab.user else { fatalError("not data currentUser")  }
        return user
    }
    
    func fetchPosts(completion: @escaping() -> ()) {
        postService.fetchPosts { posts in
            self.posts = posts
            completion()
        }
    }
    
    func fetchFeedPosts(completion: @escaping() -> () ) {
        postService.fetchFeedPosts { posts in
            self.posts = posts
            completion()
        }
    }
    
    func fetchStories() {
        historyService.fetchStories { stories in
            self.stories = stories
        }
    }
    
    func fetchFollowings(uid: String, completion: @escaping([User]) -> Void) {
        followService.fetchFollowings(uid: uid) { users in
            completion(users)
        }
    }
    
    func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        postService.updateUserFeedAfterFollowing(user: user, didFollow: didFollow )
    }
    
    func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        postService.likePost(post: post) { error in
            completion(error)
        }
    }
    
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        postService.unlikePost(post: post) { error in
            completion(error)
        }
    }
    
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void) {
        postService.checkIfUserLikePost(post: post) { didLike in
            completion(didLike)
        }
    }
    
    func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        notificationService.uploadNotification(
            toUid: uid,
            fromUser: fromUser,
            type: type,
            post: post)
    }
    
    func numberOfSections() -> Int {
        return self.posts.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if self.posts.count != 0 {
            return self.posts.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Post {
        return posts[indexPath.row]
    }
}

