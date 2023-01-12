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
    
    // MARK: - Properties
    
    static let shared = AuthManager()
    
    let db = Firestore.firestore()
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    var accessToken: Any? {
        return Auth.auth().currentUser
    }
    
    
    // MARK: - Login Logout
    
    func logUserIn(withEmail email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firebaseUser, error) in
            completionBlock(error == nil)
        })
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
