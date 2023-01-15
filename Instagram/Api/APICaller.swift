//
//  APICaller.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//


import Firebase

/// Final APICaller
final class APICaller {
    
    // MARK: - Properties
    
    static let shared = APICaller()
    let db = Firestore.firestore()
    
    private init() {}
        
    enum APIError: Error {
        case faileedToGetData
    }


    // MARK: - Fetch UserLogin
    
    func fetchUserLogin(completion: @escaping (Result<User, Error>) -> Void) {
        guard let email = Auth.auth().currentUser?.email else { return }
        db.collection("users").whereField("email", isEqualTo: email)
        .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(.failure(APIError.faileedToGetData))
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let dictionary = document.data()
                        let user = User(dictionary: dictionary)
                        completion(.success(user))
                    }
                    
                }
        }
    }
    
    // MARK: - Users
    
    func fetchUser(email: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        completion(.failure(APIError.faileedToGetData))
                    } else {
                        for document in querySnapshot!.documents {
                            //print("\(document.documentID) => \(document.data())")
                            let dictionary = document.data()
                            let user = User(dictionary: dictionary)
                            completion(.success(user))
                        }
                        
                    }
            }
    }
    
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                /*for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    let user = User(dictionary: document.data())
                    users.append(user)
                }*/
                
                /*querySnapshot?.documents.forEach({ document in
                    let user = User(dictionary: document.data())
                    users.append(user)
                })
                completion(.success(users))*/
                
                guard let users = querySnapshot?.documents.compactMap({ User(dictionary: $0.data()) }) else {
                    return
                }
                completion(.success(users))
            }
        }
    }
    
    // MARK: - Comments
    
    
    // MARK: - Post
    
    
    // MARK: - Follows

}
