//
//  UploadPostViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import UIKit
import Firebase

class UploadPostViewModel {
    
    // MARK: - Porperties
    
    let postService: PostServiceDelegate
    
    
    // MARK: - Lifecycle
    
    init(postService: PostServiceDelegate = PostService()) {
        self.postService = postService
    }
    
    // MARK: - Helper
    
    func uploadPost( caption: String, image: UIImage, user: User, completion: @escaping ( Error? ) -> Void ) {
        postService.uploadPost(caption: caption, image: image, user: user) { error in
            completion(error)
        }
    }
    
    func updatePost(post: Post, completion: @escaping (Error?) -> Void ) {
        postService.updatePost(post: post) { error in
            completion(error)
        }
    }
}
