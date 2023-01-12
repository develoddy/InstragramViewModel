//
//  NotificationCategory.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 12/1/23.
//

import Foundation

enum NotificationCategory {
    case week(model: Notifications) // Esta semana
    case previous(model: Notifications) // Anteriores
}
