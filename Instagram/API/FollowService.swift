//
//  FollowService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 25/1/23.
//

import Foundation

protocol FollowServiceDelegate: AnyObject {
    func fetchFollowings(uid: String, completion: @escaping([User]) -> Void)
    func fetchFollowers(uid: String, completion: @escaping([User]) -> Void)
}

class FollowService: FollowServiceDelegate {
    
    // MARK: - Properties
    
    ///static let shared = ProfileService()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    // Siguiendo
    func fetchFollowings(uid: String, completion: @escaping([User]) -> Void) {
        Constants.Collections.COLLECTION_FOLLOWINGS.document(uid).collection("user-followings")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let posts = documents.compactMap({ User(dictionary: $0.data() ) })
                completion(posts)
        }
    }

    func fetchFollowers(uid: String, completion: @escaping([User]) -> Void) {
        Constants.Collections.COLLECTION_FOLLOWERS.document(uid).collection("user-followers")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else { return }
                let posts = documents.compactMap({ User(dictionary: $0.data() ) })
                completion(posts)
        }
    }
}
