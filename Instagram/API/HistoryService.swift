//
//  StoriesService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//


import Foundation

protocol HistoryServiceDelegate: AnyObject {
    func fetchStories(completion: @escaping( [ History ] ) -> Void)
}

class HistoryService: HistoryServiceDelegate {
    
    // MARK: - Properties
    
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    
    // MARK: - Helpers
    /*
     func fetchUser(uid: String, completion: @escaping (User) -> Void) {
         Constants.Collections.COLLECTION_USERS.document(uid).getDocument { snapshot, _ in
             guard let dictionary = snapshot?.data() else { return }
             let user = User(dictionary: dictionary)
             completion(user)
         }
     }
     */
    
    /*
     func fetchPosts(completion: @escaping([Post]) -> Void) {
         Constants.Collections.COLLECTION_POSTS.order(by: "timestamp", descending: true)
             .getDocuments { (snapshot, error) in
                 guard let documents = snapshot?.documents else { return }
                 let posts = documents.compactMap( { Post( postId: $0.documentID, dictionary: $0.data() ) } )
                 completion( posts )
         }
     }
     */
    
    func fetchStories(completion: @escaping( [ History ] ) -> Void) {
        Constants.Collections.COLLECTION_STORIES.order(by: "timestamp", descending: true).getDocuments { ( snapshot, error ) in
            guard let documents = snapshot?.documents else { return }
            let stories = documents.compactMap( { History(storieId: $0.documentID, dictionary: $0.data()) } )
            completion(stories)
        }
    }
    
    func fetchStoriesCurrentUser() {}
}
