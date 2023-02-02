//
//  CommentService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import Firebase

typealias FirestoreCompletion = (Error?) -> Void


class UserService {
    
    // MARK: - Properties
    
    static let shared = UserService()
    
    let db = Firestore.firestore()
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    func fetchUserLogin(completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection("users").whereField("email", isEqualTo: email)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                for document in querySnapshot!.documents {
                    let dictionary = document.data()
                    let user = User(dictionary: dictionary)
                    completion(.success(user))
                }
                
            }
        }
    }
    
    func registerUser() {
        //
    }
    
    func fetchUser(uid: String, completion: @escaping (Result<User, Error>) -> Void) {
        Constants.Collections.COLLECTION_USERS.document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                guard let dictionary = snapshot?.data() else { return }
                let user = User(dictionary: dictionary)
                completion(.success(user))
            }
        }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                guard let users = querySnapshot?.documents.compactMap({ User(dictionary: $0.data()) }) else {
                    return
                }
                completion(.success(users))
            }
        }
    }
    
    func updateUserValue(uid: String, label: String, value: String, completion: @escaping(FirestoreCompletion)) {
        Constants.Collections.COLLECTION_USERS.document(uid)
            .updateData(
                [label : value],
                completion: completion
            )
    }
}

