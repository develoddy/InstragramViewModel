//
//  CommentService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import Firebase

protocol CommentServiceDelegate: AnyObject {
    func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion))
}

class CommentService: CommentServiceDelegate {
    
    // MARK: - Properties
    
    static let shared = CommentService()
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    func uploadComment(
        comment: String,
        postID: String,
        user: User,
        completion: @escaping(FirestoreCompletion)
    ) {
        let data: [String: Any] = [
            "uid": user.uid,
            "comment": comment,
            "timestamp": Timestamp(date: Date()),
            "username": user.username,
            "profileImageURL": user.profileImageURL
        ]
        
        Constants.Collections.COLLECTION_POSTS.document(postID).collection("comments").addDocument(
            data: data,
            completion: completion
        )
    }
}
