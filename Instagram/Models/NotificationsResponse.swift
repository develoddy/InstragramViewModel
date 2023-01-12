//
//  NotificationsResponse.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import Foundation

struct NotificationsResponse: Codable {
    let notifications: NotificationsItemsResponse
    let previous: previousItemsResponse
    
}

struct NotificationsItemsResponse: Codable {
    let items: [Notifications]
}

struct previousItemsResponse: Codable  {
    let items: [Notifications]
}
