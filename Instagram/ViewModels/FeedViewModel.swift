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
    
    let api: APICallerDelegate
    
    var refreshData: ( () -> () )?
    
    var posts: [Post] = [Post]() {
        didSet {
            refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(api: APICallerDelegate = APICaller()) {
        self.api = api
    }
    
    // MARK: - Helpers
    
    
    func fetchPosts(completion: @escaping() -> ()) {
        api.fetchPosts { posts in
            self.posts = posts
            completion()
        }
    }
    
    func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        api.likePost(post: post) { error in
            completion(error)
        }
    }
    
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        api.unlikePost(post: post) { error in
            completion(error)
        }
    }
    
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void) {
        api.checkIfUserLikePost(post: post) { didLike in
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
