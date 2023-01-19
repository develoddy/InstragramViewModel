//
//  File.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 18/1/23.
//

import Foundation

class CommentViewModel {
    
    // MARK: - Porperties
    
    let api: CommentServiceDelegate
    
    var refreshData: ( () -> () )?
    
    var post: Post? {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Init
    
    init(api: CommentServiceDelegate = CommentService()) {
        self.api = api
    }
    
    // MARK: - Helpers
    func uploadComment(comment: String,
                       postID: String,
                       user: User,
                       completion: @escaping (Error?) -> Void
    ) {
        api.uploadComment(comment: comment, postID: postID, user: user) { error in
            completion(error)
        }
    }
    
    func numberOfSections() -> Int {
        return 0
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        /*if self.posts.count != 0 {
            return self.posts.count
        }
        return 0*/
        return 0
    }
    
    /*func cellForRowAt(indexPath: IndexPath) -> Post {
        return self.posts[indexPath.row]
    }*/
    
}
