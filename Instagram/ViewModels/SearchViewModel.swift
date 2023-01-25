//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 24/1/23.
//

import Foundation

class SearchViewModel {
    
    // MARK: - Properties
    
    let postService: PostServiceDelegate
    
    var refreshData: ( () -> () )?
    
    var posts: [Post] = [Post]() {
        didSet {
            refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        postService: PostServiceDelegate = PostService()
    ) {
        self.postService = postService
    }
    
    // MARK: - Helpers
    
    func fetchPosts(completion: @escaping() -> ()) {
        postService.fetchPosts { posts in
            self.posts = posts
            completion()
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
        return self.posts[indexPath.row]
    }
}
