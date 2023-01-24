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
    
    var refreshData: ( () -> () )?
    
    var notifications: [Notification] = [Notification]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Lifecycle
    
    init(notificationService: NotificationServiceDelegate = NotificationService()) {
        self.notificationService = notificationService
    }
    
    // MARK: - Helpers
    ///func fetchNotifications(completion: @escaping([Notification]) -> Void) {
    func fetchNotifications(completion: @escaping() -> () ) {
        notificationService.fetchNotifications { notifications in
            print("DEBUG: ViewModel Notification")
            print(notifications)
            self.notifications = notifications
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
