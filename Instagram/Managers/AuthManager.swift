//
//  AuthManager.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 5/1/23.
//

import Foundation
import Firebase
import UIKit

struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImageURL: UIImage
}

final class AuthManager {
    
    static let shared = AuthManager()
    
    // var user: User?
    
    var user: Firebase.User?
    
    let db = Firestore.firestore()
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    var accessToken: Any? {
        return Auth.auth().currentUser
    }
    
    public func logUserIn(
        withEmail email: String,
        password: String,
        completion: @escaping ((AuthDataResult?, Error?) -> Void)
    ) {
        DispatchQueue.main.async {
            Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        }
    }
    
    public func signOut(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        } catch {
            print("Debug: Failed to sign out")
            completion(false)
        }
    }
}
