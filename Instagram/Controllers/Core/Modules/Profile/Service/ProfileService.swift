//
//  ProfileService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 16/1/23.
//

import Foundation
import Firebase

protocol ProfileServiceDelegate: AnyObject {
    //func getUserPost(token: String, completion : @escaping ((Result<UserPostData, Error>)) -> ())
    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void)
    func follow(uid: String, completion: @escaping(FirestoreCompletion))
    func unfollow(uid: String, completion: @escaping(FirestoreCompletion))
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void)
}

final class ProfileService: ProfileServiceDelegate {
    
    // MARK: - Properties
    static let shared = ProfileService()
    
    let db = Firestore.firestore()
    
    // MARK: - Init
    //private init() {}
    
    struct Constants {
        //static let baseAPIURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Helpers
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void)  {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-followings").document(uid).getDocument { (snapshot, error) in
            guard let isFollowed = snapshot?.exists else { return }
            completion(isFollowed)
        }
    }
    
    func follow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-followings")
            .document(uid).setData([:]) { error in
                
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).setData([:], completion: completion)
        }
    }
    
    func unfollow(uid: String, completion: @escaping(FirestoreCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        COLLECTION_FOLLOWINGS.document(currentUid).collection("user-followings")
            .document(uid).delete { error in
                
                COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
                    .document(currentUid).delete(completion: completion)
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { (snapshot, _) in
            let followers = snapshot?.documents.count ?? 0
            
            COLLECTION_FOLLOWINGS.document(uid).collection("user-followings").getDocuments { (snapshot, _) in
                let followings = snapshot?.documents.count ?? 0
                
                completion(UserStats(followers: followers, following: followings))
            }
        }
    }
}
