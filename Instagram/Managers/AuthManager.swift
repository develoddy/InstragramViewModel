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
    
    var handle: AuthStateDidChangeListenerHandle?
    
    static let shared = AuthManager()
    
    let db = Firestore.firestore()
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: User? {
        return self.getUser()
    }
    
    enum APIError: Error {
        case faileedToGetData
    }
        
    func getUser() -> User? {
        var userDic: User? = nil
        let user = Auth.auth().currentUser
        if user != nil {
            let dic:[String:Any] = ["email":user?.email ?? "", "fullname": "", "profileImageURL": "", "username": "", "uid":user?.uid ?? ""]
            userDic = User(dictionary: dic)
        } else {
            print("Document does not exist")
        }
        return userDic
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
