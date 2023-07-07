//
//  Constants.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//

import Firebase

struct Constants {
    
    struct Collections {
        static let COLLECTION_USERS = Firestore.firestore().collection("users")
        static let COLLECTION_FOLLOWERS = Firestore.firestore().collection("followers")
        static let COLLECTION_FOLLOWINGS = Firestore.firestore().collection("followings")
        static let COLLECTION_POSTS = Firestore.firestore().collection("posts")
        static let COLLECTION_NOTIFICATIONS = Firestore.firestore().collection("notifications")
        static let COLLECTION_STORIES = Firestore.firestore().collection("stories")
    }
    
    struct PostView {
        static let alertActionTitleDelete = "Delete"
        static let alertActionTitleCancel = "Cancel"
    }
}
