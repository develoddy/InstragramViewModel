//
//  CommentService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import Firebase

protocol CommentServiceDelegate: AnyObject {
    func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion))
    func fetchComments(forPost postID: String, completion: @escaping (Result<[Comment], Error>) -> Void)
}

class CommentService: CommentServiceDelegate {
    
    // MARK: - Properties
    
    static let shared = CommentService()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
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
    
    // func fetchUserLogin(completion: @escaping (Result<User, Error>) -> Void) {
    func fetchComments(
        forPost postID: String,
        completion: @escaping (Result<[Comment], Error>) -> Void
        //completion: @escaping([Comment]) -> Void
    ) {
        var comments = [Comment]()
        let query = Constants.Collections.COLLECTION_POSTS.document(postID).collection("comments").order(by: "timestamp", descending: true)
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG: Error fetch comment: \(error)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                snapshot?.documentChanges.forEach({ change in
                    if change.type == .added {
                        let data = change.document.data()
                        let comment = Comment(dictionary: data)
                        comments.append(comment)
                    }
                })
                completion(.success(comments))
            }
            
        }
    }
}
