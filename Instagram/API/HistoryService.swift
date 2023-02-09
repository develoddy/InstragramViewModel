//
//  StoriesService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//


import Firebase

protocol HistoryServiceDelegate: AnyObject {
    func uploadHistory( image: UIImage, currentUser: User, completion: @escaping( FirestoreCompletion ) )
    func fetchStories( completion: @escaping( [ History ] ) -> Void )
    func fetchStoriesCurrentUser(forUser uid: String, completion: @escaping( [ History ] ) -> Void)
}

class HistoryService: HistoryServiceDelegate {
    
    // MARK: - Properties
    
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    
    // MARK: - Helpers
    
    func uploadHistory( image: UIImage, currentUser: User, completion: @escaping( FirestoreCompletion ) ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = [
                "imageURL": imageURL,
                "ownerImageURL": currentUser.profileImageURL,
                "ownerUid": uid,
                "ownerUsername": currentUser.username,
                "timestamp": Timestamp(date: Date()),
            ] as [String: Any]
            
            Constants.Collections.COLLECTION_STORIES.addDocument( data: data, completion: completion )
        }
    }
    
    func fetchStories(completion: @escaping( [ History ] ) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ///Constants.Collections.COLLECTION_STORIES.order(by: "timestamp", descending: false).getDocuments { ( snapshot, error ) in
        Constants.Collections.COLLECTION_STORIES.whereField("ownerUid", isNotEqualTo: uid).getDocuments { ( snapshot, error ) in
            guard let documents = snapshot?.documents else { return }
            let stories = documents.compactMap( { History(storieId: $0.documentID, dictionary: $0.data()) } )
            ///stories.sort( by: { $0.timestamp.seconds > $1.timestamp.seconds } )
            completion(stories)
        }
    }
    
    func fetchStoriesCurrentUser(forUser uid: String, completion: @escaping( [ History ] ) -> Void) {
        let query = Constants.Collections.COLLECTION_STORIES.whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { snapshot, err in
            guard let documents = snapshot?.documents else { return }
            let stories = documents.compactMap( { History( storieId: $0.documentID, dictionary: $0.data() ) } )
            /**
             posts.sort( by: { $0.timestamp.seconds > $1.timestamp.seconds } )
             posts.sort { (post1, post2) -> Bool in
                 return post1.timestamp.seconds > post2.timestamp.seconds
             }
             */
            completion(stories)
        }
    }
}
