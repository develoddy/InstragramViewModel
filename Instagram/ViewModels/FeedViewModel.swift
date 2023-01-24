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
    
    var refreshData: ( () -> () )?
    
    var posts: [Post] = [Post]() {
        didSet {
            refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(postService: PostServiceDelegate = PostService()) {
        self.postService = postService
    }
    
    // MARK: - Helpers
    
    
    func fetchPosts(completion: @escaping() -> ()) {
        postService.fetchPosts { posts in
            self.posts = posts
            completion()
        }
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
