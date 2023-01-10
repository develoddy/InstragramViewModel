//
//  APICaller.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/1/23.
//


import Firebase
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

final class APICaller {
    
    static let shared = APICaller()
    let db = Firestore.firestore()
    
    private init() {}
        
    enum APIError: Error {
        case faileedToGetData
    }
    
    /*
     Obtener varios documentos de una colección
     También puede recuperar varios documentos con una sola solicitud consultando
     los documentos de una colección. Por ejemplo, puede usar where() para
     consultar todos los documentos que cumplen una determinada condición y luego usar get()
     para recuperar los resultados:
     */
    func fetchUser(email: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").whereField("email", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
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
    
    /*func completeList(completion: @escaping (Result<[User], Error>) -> ()) {
        var users = [User]()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completion(.failure(APIError.faileedToGetData))
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let user = User(dictionary: document.data())
                    users.append(user)
                }
                completion(.success(users))
            }
        }
    }*/
    
    
    // Recuperar el contenido de un solo documento usando get
    /*func getOneDocumentData() {
        let docRef = db.collection("users").document("5hylxObE98Xtry4KGVev")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
            }
        }
    }*/
}
