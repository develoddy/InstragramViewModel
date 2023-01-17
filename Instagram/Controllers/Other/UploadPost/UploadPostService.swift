//
//  PostService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import Foundation
import Firebase

protocol UploadPostServiceDelegate: AnyObject {
    func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion))
}

final class UploadPostService: UploadPostServiceDelegate {
    
    // MARK: - Properties
    static let shared = UploadPostService()
    
    let db = Firestore.firestore()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ImageUploader.uploadImage(image: image) { imageURL in
            let data = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageURL": imageURL,
                "ownerUid": uid
            ] as [String: Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
    }
}
