//
//  NotificationViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 24/1/23.
//

import Foundation

class NotificationViewModel {
    
    // MARK: - Properties
    
    let notificationService : NotificationServiceDelegate
    
    let profileService: ProfileServiceDelegate
    
    let postService: PostServiceDelegate
    
    var refreshData: ( () -> () )?
    
    var notifications: [Notification] = [Notification]() {
        didSet {
            self.refreshData?()
        }
    }
    
    var post: Post? {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(
        notificationService: NotificationServiceDelegate = NotificationService(),
        profileService: ProfileServiceDelegate = ProfileService(),
        postService: PostServiceDelegate = PostService()
    ) {
        self.notificationService = notificationService
        self.profileService = profileService
        self.postService = postService
    }
    
    // MARK: - Helpers
    func fetchNotifications(completion: @escaping() -> () ) {
        notificationService.fetchNotifications { notifications in
            print("DEBUG: ViewModel Notification")
            print(notifications)
            self.notifications = notifications
            completion()
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        profileService.checkIfUserIsFollowed(uid: uid) { isFollowed in
            completion(isFollowed)
        }
    }
    
    func fetchPosts(withPostId postId: String, completion: @escaping() -> () ) {
        postService.fetchPosts(withPostId: postId) { post in
            self.post = post
            completion()
        }
    }
    
    func numberOfSections() -> Int {
        return self.notifications.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if self.notifications.count != 0 {
            return self.notifications.count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> Notification {
        return self.notifications[indexPath.row]
    }
}
