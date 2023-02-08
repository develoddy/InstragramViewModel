//
//  Stories.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//

import Foundation
import Firebase

struct History {
    var imageURL: String
    let ownerUsername: String
    var storieId: String
    var ownerUid: String
    var timestamp: Timestamp
    
    init(storieId: String, dictionary: [String: Any]) {
        self.imageURL = dictionary["imageURL"] as? String ?? ""
        self.ownerUsername = dictionary["ownerUsername"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.ownerUid = dictionary["ownerUid"] as? String ?? ""
        self.storieId = storieId
    }
}
