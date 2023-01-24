//
//  CommentService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import Firebase

protocol PostServiceDelegate: AnyObject {
    func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion))
    func fetchPosts(completion: @escaping([Post]) -> Void)
    func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void)
    func likePost(post: Post, completion: @escaping(FirestoreCompletion))
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion))
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void)
}

class PostService: PostServiceDelegate {
    
    // MARK: - Properties
    
    ///static let shared = PostService()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageURL": imageURL,
                "ownerUid": uid,
                "ownerImageURL": user.profileImageURL,
                "ownerUsername": user.username,
            ] as [String: Any]
            
            Constants.Collections.COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        Constants.Collections.COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            let posts = documents.compactMap({ Post(postId: $0.documentID, dictionary: $0.data() )})
            completion(posts)
        }
    }
    
    func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void) {
        let query = Constants.Collections.COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            
            var posts = documents.compactMap({ Post(postId: $0.documentID, dictionary: $0.data() )})
            posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }
            
            completion(posts)
        }
    }
    
    func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Collections.COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes + 1])
        
        Constants.Collections.COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).setData([:]) { _ in
            
                Constants.Collections.COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).setData([:], completion: completion)
        }
    }
    
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard post.likes > 0 else { return }
        
        Constants.Collections.COLLECTION_POSTS.document(post.postId).updateData(["likes": post.likes - 1])
        
        Constants.Collections.COLLECTION_POSTS.document(post.postId).collection("post-likes").document(uid).delete { _ in
            
                Constants.Collections.COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).delete(completion: completion)
        }
    }
    
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Collections.COLLECTION_USERS.document(uid).collection("user-likes").document(post.postId).getDocument {
            (snapshot, _) in
            guard let didLike = snapshot?.exists else { return }
            completion(didLike)
        }
    }
    
}
