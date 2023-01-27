//
//  File.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 18/1/23.
//

import Foundation

class CommentViewModel {
    
    // MARK: - Porperties
    
    let api: CommentServiceDelegate
    
    let notificationService: NotificationServiceDelegate
    
    var refreshData: ( () -> () )?
        
    var post: Post? {
        didSet {
            self.refreshData?()
        }
    }
    
    var comments: [Comment] = [Comment]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Init
    
    init(
        api: CommentServiceDelegate = CommentService(),
        notificationService: NotificationServiceDelegate = NotificationService()
    ) {
        self.api = api
        self.notificationService = notificationService
    }
    
    // MARK: - Helpers
    
    func uploadComment(comment: String,
                       postID: String,
                       user: User,
                       completion: @escaping (Error?) -> Void
    ) {
        api.uploadComment(comment: comment, postID: postID, user: user) { error in
            completion(error)
        }
    }
    
    func fetchComments(forPost postID: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        api.fetchComments(forPost: postID) { result in
           completion(result)
        }
    }
    
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                completion(.success(user))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func uploadNotification(toUid uid: String, fromUser: User, type: NotificationType, post: Post? = nil) {
        notificationService.uploadNotification(
            toUid: uid,
            fromUser: fromUser,
            type: type,
            post: post)
    }
    
    func numberOfSections() -> Int {
        return self.comments.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if self.comments.count != 0 {
            return self.comments.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Comment {
        return self.comments[indexPath.row]
    }
}
