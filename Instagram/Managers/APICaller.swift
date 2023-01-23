//
//  APICaller.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//


import Firebase

typealias FirestoreCompletion = (Error?) -> Void


protocol APICallerDelegate: AnyObject {
    func fetchUserLogin(completion: @escaping (Result<User, Error>) -> Void)
    func registerUser()
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void)
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void)
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void)
    func follow(uid: String, completion: @escaping(FirestoreCompletion))
    func unfollow(uid: String, completion: @escaping(FirestoreCompletion))
    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void)
    func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion))
    func fetchPosts(completion: @escaping([Post]) -> Void)
    func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void)
    func likePost(post: Post, completion: @escaping(FirestoreCompletion))
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion))
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void)
}

/// Final APICaller
final class APICaller: APICallerDelegate {
    
    // MARK: - Properties
    
    static let shared = APICaller()
    
    let db = Firestore.firestore()
    
    //private init() {}
        
    enum APIError: Error {
        case faileedToGetData
    }


    // MARK: - Login && Register
    
    func fetchUserLogin(completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection("users").whereField("email", isEqualTo: email)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(.failure(APIError.faileedToGetData))
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let dictionary = document.data()
                        let user = User(dictionary: dictionary)
                        completion(.success(user))
                    }
                    
                }
        }
    }
    
    func registerUser() {
        //
    }
    
    // MARK: - Users

    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        Constants.Collections.COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                guard let dictionary = snapshot?.data() else { return }
                let user = User(dictionary: dictionary)
                completion(.success(user))
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                guard let users = querySnapshot?.documents.compactMap({ User(dictionary: $0.data()) }) else {
                    return
                }
                completion(.success(users))
            }
        }
    }
    
    
    // MARK: - Follows
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void)  {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Constants.Collections.COLLECTION_FOLLOWINGS.document(currentUid).collection("user-followings").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Constants.Collections.COLLECTION_FOLLOWINGS.document(currentUid).collection("user-followings")
            .document(uid).setData([:]) { error in
                print("DEBG: follow: ")
                print(error as Any)
                Constants.Collections.COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).setData([:], completion: completion)
        }
    }
    
    func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        Constants.Collections.COLLECTION_FOLLOWINGS.document(currentUid).collection("user-followings")
            .document(uid).delete { error in
                print("DEBG: unfollow: ")
                print(error as Any)
                Constants.Collections.COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).delete(completion: completion)
        }
    }
    

    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        Constants.Collections.COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            Constants.Collections.COLLECTION_FOLLOWINGS.document(uid).collection("user-followings").getDocuments { (snapshot, _) in
                let followings = snapshot?.documents.count ?? 0
                
                Constants.Collections.COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid).getDocuments { (snapshot, _) in
                    let posts = snapshot?.documents.count ?? 0
                    completion(UserStats(followers: followers, following: followings, posts: posts))
                }
            }
        }
    }
    
    
    // MARK: - Posts
    
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
    
    
    // MARK: - Comments
}
