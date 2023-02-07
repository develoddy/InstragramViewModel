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
    
    let notificationService: NotificationServiceDelegate
    
    var followService: FollowServiceDelegate
    
    var refreshData: ( () -> () )?
    
    var post: Post? {
        didSet {
            refreshData?()
        }
    }
    
    var stories: [String] = [String]() {
        didSet {
            refreshData?()
        }
    }
  
    var posts: [Post] = [Post]() {
        didSet {
            refreshData?()
        }
    }
    
    var sections: [BrowseSectionType] = [BrowseSectionType]() {
        didSet {
            refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        postService: PostServiceDelegate = PostService(),
        followService: FollowServiceDelegate = FollowService(),
        notificationService: NotificationServiceDelegate = NotificationService()
    ) {
        self.postService = postService
        self.followService = followService
        self.notificationService = notificationService
    }
    
    // MARK: - Helpers
    
    //func fetchPosts(uid: String, completion: @escaping() -> ()) {
        //postService.fetchPosts(forUser: uid) { posts in
    func fetchPosts(withPostId: String, completion: @escaping () -> ()) {
        var arrPost = [Post]()
        postService.fetchPosts(withPostId: withPostId) { post in
            arrPost.append(post)
            self.sections.append(.feeds(viewModels: arrPost.compactMap({
                return $0
            })))
            completion()
        }
        
        self.stories.append("name1")
        self.stories.append("name2")
        self.stories.append("name3")
        
        sections.append(.stories(viewModels: stories.compactMap({
            return $0
        })))
    }
    
    func fetchFeedPosts(completion: @escaping() -> () ) {
        postService.fetchFeedsPosts { posts in
            self.sections.append(.feeds(viewModels: posts.compactMap( {
                return $0
            })))
            completion()
        }
        
        self.stories.append("name1")
        self.stories.append("name2")
        self.stories.append("name3")
        
        sections.append(.stories(viewModels: stories.compactMap({
            return $0
        })))
    }
    
    func fetchFollowings(uid: String, completion: @escaping([User]) -> Void) {
        followService.fetchFollowings(uid: uid) { users in
            completion(users)
        }
    }
    
    func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        postService.updateUserFeedAfterFollowing(user: user, didFollow: didFollow )
    }
    
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void) {
        postService.checkIfUserLikePost(post: post) { didLike in
            completion(didLike)
        }
    }
    
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        postService.unlikePost(post: post) { error in
            completion(error)
        }
    }
    
    func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        postService.likePost(post: post) { error in
            completion(error)
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
        return sections.count
    }
 
    func numberOfRowsInSection(section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .stories(let viewModels):
            return viewModels.count
        case .feeds(let viewModels):
            return viewModels.count
        }
    }
    
    func cellForRowAt(indexPath: IndexPath) -> BrowseSectionType {
        return sections[indexPath.section]
    }
}








/////////

/**
class FeedViewModel {
    
    // MARK: - Properties
    
    let postService: PostServiceDelegate
    
    let notificationService: NotificationServiceDelegate
    
    var followService: FollowServiceDelegate
    
    var refreshData: ( () -> () )?
    
    var post: Post? {
        didSet {
            refreshData?()
        }
    }
    
    var posts: [Post] = [Post]() {
        didSet {
            refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        postService: PostServiceDelegate = PostService(),
        notificationService: NotificationServiceDelegate = NotificationService(),
        followService: FollowServiceDelegate = FollowService()
    ) {
        self.postService = postService
        self.notificationService = notificationService
        self.followService = followService
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
*/
