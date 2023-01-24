//
//  NotificationService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 24/1/23.
//

import Firebase

protocol NotificationServiceDelegate: AnyObject {
    func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post?)
    func fetchNotifications(completion: @escaping([Notification]) -> Void)
}

class NotificationService: NotificationServiceDelegate {
    
    // MARK: - Properties
    
    ///static let shared = CommentService()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    
    // MARK: - Helpers
    
    func uploadNotification(
        toUid uid: String,
        fromUser: User,
        type: NotificationType,
        post: Post? = nil
    ) {
        guard let currentuid = Auth.auth().currentUser?.uid else { return }
        guard uid != currentuid else { return }
        
        // Get id from Document
        let docRef = Constants.Collections.COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").document()
        
        var data: [String: Any] = [
            "timestamp": Timestamp(date: Date()),
            "uid": fromUser.uid,
            "type": type.rawValue,
            "id": docRef.documentID,
            "userProfileImageURL": fromUser.profileImageURL,
            "username": fromUser.username
        ]
        
        if let post = post {
            data["postId"] = post.postId
            data["postImageURL"] = post.imageURL
        }
        
        docRef.setData(data)
        
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Collections.COLLECTION_NOTIFICATIONS.document(uid).collection("user-notifications").getDocuments { snapshot, error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                guard let documents = snapshot?.documents else { return }
                let notifications = documents.map({ Notification(dictionary: $0.data()) })
                completion(notifications)
            }
        }
    }
    
}

