//
//  File.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 18/1/23.
//

import Foundation

class PostsSettingViewControllerViewModel {
    
    // MARK: - Porperties
    
    let api: APICallerDelegate
    
    var refreshData: ( () -> () )?
    
    var posts: [Post] = [Post]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Init
    
    init(api: APICallerDelegate = APICaller()) {
        self.api = api
    }
    
    // MARK: - Helpers
    func fetchPosts(uid: String) {
        api.fetchPosts(forUser: uid) { [weak self] postsData in
            self?.posts = postsData
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
        return self.posts[indexPath.section]
    }
    
}
