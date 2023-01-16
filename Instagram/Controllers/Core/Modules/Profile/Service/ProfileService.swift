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
