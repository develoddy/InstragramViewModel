//
//  CommentService.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 19/1/23.
//

import Firebase

protocol PostServiceDelegate: AnyObject {
    func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion))
    func fetchPosts(completion: @escaping([Post]) -> Void)
    func fetchPosts(forUser uid: String, completion: @escaping([Post]) -> Void)
    func likePost(post: Post, completion: @escaping(FirestoreCompletion))
    func unlikePost(post: Post, completion: @escaping(FirestoreCompletion))
    func checkIfUserLikePost(post: Post, completion: @escaping(Bool) -> Void)
    func fetchPosts(withPostId postId: String, completion: @escaping(Post) -> Void )
    func fetchFeedPosts(completion: @escaping([Post]) -> Void )
    func updateUserFeedAfterFollowing(user: User, didFollow: Bool)
    func deletePost(withPostId postId: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func updatePost(post: Post, completion: @escaping(FirestoreCompletion))
}

class PostService: PostServiceDelegate {
    
    // MARK: - Properties
    
    ///static let shared = PostService()
    
    var followService: FollowServiceDelegate
    
    enum APIError: Error {
        case faileedToGetData
    }
    
    // MARK: - Lifecycle
    init(
        followService: FollowServiceDelegate = FollowService()
    ) {
        self.followService = followService
    }
    
    // MARK: - Helpers
    
    func uploadPost(caption: String, image: UIImage, user: User, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        ImageUploader.uploadImage( image: image ) { imageURL in
            let data = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageURL": imageURL,
                "ownerUid": uid,
                "ownerImageURL": user.profileImageURL,
                "ownerUsername": user.username,
            ] as [String: Any]
            
            let docRef = Constants.Collections.COLLECTION_POSTS.addDocument( data: data, completion: completion )
            self.updateUserFeedAfterPost( postId: docRef.documentID )
            self.updateUserFeedAfterUserPost( postId: docRef.documentID )
        }
    }
    
    func fetchPosts(completion: @escaping([Post]) -> Void) {
        Constants.Collections.COLLECTION_POSTS.order(by: "timestamp", descending: true)
            .getDocuments { (snapshot, error) in
                guard let documents = snapshot?.documents else { return }
                let posts = documents.compactMap( { Post( postId: $0.documentID, dictionary: $0.data() ) } )
                completion( posts )
        }
    }
    
    func fetchPosts(forUser uid: String, completion: @escaping( [ Post ] ) -> Void) {
        let query = Constants.Collections.COLLECTION_POSTS.whereField("ownerUid", isEqualTo: uid)
        query.getDocuments { (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            var posts = documents.compactMap( { Post( postId: $0.documentID, dictionary: $0.data() ) } )
            posts.sort( by: { $0.timestamp.seconds > $1.timestamp.seconds } )
            /**posts.sort { (post1, post2) -> Bool in
                return post1.timestamp.seconds > post2.timestamp.seconds
            }*/
            completion(posts)
        }
    }
    
    func fetchPosts(withPostId postId: String, completion: @escaping( Post ) -> Void ) {
        Constants.Collections.COLLECTION_POSTS.document(postId).getDocument { snapshot, _ in
            guard let snapshot = snapshot else { return }
            guard let data = snapshot.data() else { return }
            let post = Post(postId: snapshot.documentID, dictionary: data)
            completion(post)
        }
    }

    func fetchFeedPosts(completion: @escaping( [ Post ] ) -> Void ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        Constants.Collections.COLLECTION_USERS.document( uid ).collection("user-feed")
            .getDocuments { snapshot, error in
                snapshot?.documents.forEach( { document in
                    self.fetchPosts( withPostId: document.documentID ) { post in
                        posts.append(post)
                        posts.sort( by: { $0.timestamp.seconds > $1.timestamp.seconds } )
                        completion( posts )
                }
            })
        }
    }
    
 
    
    func deletePost(withPostId postId: String, completion: @escaping ( Result<Bool, Error> ) -> Void ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        /*
         * HAY QUE COMPROBAR SI EXISTEN USUARIOS QUE ME SIGUEN
         * DEPENDIENDO DE REALIZARA EL CORRESPONDIENTO BORRADO
         * DE LA PUBLICACI??N.
         */
        followService.fetchFollowers( uid: uid ) { followers in
            if followers.count > 0 {
                /*
                 * BORRAR LA COLECCION DE PULICACIONES
                 * Y DE LO QUE HAY DENTRO (USER-FEED) DE LA COLECCI??N DE USUARIOS
                 */
                Constants.Collections.COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, err in
                    if let err = err {
                        print("DEBUF: deletePost: \( err )")
                        completion(.failure( APIError.faileedToGetData) )
                    } else {
                        guard let documents = snapshot?.documents else { return }
                        documents.forEach { document in
                            Constants.Collections.COLLECTION_POSTS
                                .document( postId )
                                .delete()
                            
                            Constants.Collections.COLLECTION_USERS
                                .document( document.documentID )
                                .collection("user-feed")
                                .document( postId )
                                .delete()
                            
                            Constants.Collections.COLLECTION_USERS
                                .document( uid )
                                .collection("user-feed")
                                .document( postId )
                                .delete()
                            
                            completion( .success( true ) )
                        }
                    }
                }
                
            } else {
                /****
                 * SI NO HAY USUARIOS QUE ME SIGUEN ENTONCES SOLO BORRAMOS
                 * LA COLECCION DE PUBLICACIONES Y DE NUESTRO PROPIO
                 * CURRENTUSER
                 */
                print("DEBUG: Delete post y currentuser")
                Constants.Collections.COLLECTION_POSTS
                    .document(postId)
                    .delete()
                
                Constants.Collections.COLLECTION_USERS
                    .document(uid)
                    .collection("user-feed")
                    .document(postId)
                    .delete()
                
                completion(.success(true))
            }
        }
    }
    
    func updatePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        Constants.Collections.COLLECTION_POSTS.document(post.postId)
            .updateData(["caption" : post.caption], completion: completion)
    }
    
    
    func likePost(post: Post, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        Constants.Collections.COLLECTION_POSTS
            .document(post.postId)
            .updateData(["likes": post.likes + 1])
        
        Constants.Collections.COLLECTION_POSTS.document(post.postId).collection("post-likes").document( uid ).setData([:]) { _ in
                Constants.Collections.COLLECTION_USERS.document( uid )
                .collection("user-likes")
                .document(post.postId)
                .setData( [:], completion: completion )
        }
    }
    
    func unlikePost( post: Post, completion: @escaping( FirestoreCompletion ) ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        guard post.likes > 0 else { return }
        
        Constants.Collections.COLLECTION_POSTS
            .document(post.postId)
            .updateData(["likes": post.likes - 1])
        
        Constants.Collections.COLLECTION_POSTS.document( post.postId ).collection("post-likes").document( uid ).delete { _ in
                Constants.Collections.COLLECTION_USERS
                .document(uid)
                .collection("user-likes")
                .document(post.postId)
                .delete(completion: completion)
        }
    }
    
    func checkIfUserLikePost( post: Post, completion: @escaping( Bool ) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Constants.Collections.COLLECTION_USERS
            .document(uid)
            .collection("user-likes")
            .document(post.postId).getDocument { (snapshot, _) in
                guard let didLike = snapshot?.exists else { return }
                
                completion(didLike)
        }
    }
    
    func updateUserFeedAfterFollowing( user: User, didFollow: Bool ) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = Constants.Collections.COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.uid)
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            // Get count post from profile
            let docIDs = documents.map( { $0.documentID } )
            docIDs.forEach { id in
                if didFollow {
                    Constants.Collections.COLLECTION_USERS.document( uid )
                        .collection("user-feed")
                        .document( id )
                        .setData( [:] )
                } else {
                    Constants.Collections.COLLECTION_USERS.document( uid )
                        .collection("user-feed")
                        .document( id )
                        .delete()
                }
            }
        }
    }
  

    func updateUserFeedAfterPost(postId: String) {
        //Esto solo sirve para los follower
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Constants.Collections.COLLECTION_FOLLOWERS.document(uid).collection("user-followers").getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            
            documents.forEach { document in
                Constants.Collections.COLLECTION_USERS.document( document.documentID )
                    .collection("user-feed")
                    .document(postId)
                    .setData([:]
                )
                
                Constants.Collections.COLLECTION_USERS.document( uid )
                    .collection("user-feed")
                    .document(postId)
                    .setData([:])
            }
        }
    }
    
    func updateUserFeedAfterUserPost(postId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Constants.Collections.COLLECTION_USERS.document( uid )
            .collection("user-feed")
            .document( postId )
            .setData([:])
    }
}
