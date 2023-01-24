//
//  CommentService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import Firebase

protocol ProfileServiceDelegate: AnyObject {
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void)
    func follow(uid: String, completion: @escaping(FirestoreCompletion))
    func unfollow(uid: String, completion: @escaping(FirestoreCompletion))
    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void)
}

class ProfileService: ProfileServiceDelegate {
    
    // MARK: - Properties
    
    ///static let shared = ProfileService()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
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
}
