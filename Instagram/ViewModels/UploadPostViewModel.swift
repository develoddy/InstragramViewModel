//
//  UploadPostViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import Foundation
import Firebase

class UploadPostViewModel {
    
    // MARK: - Porperties
    
    //let uploadPostService : UploadPostServiceDelegate
    let api: APICallerDelegate
    
    
    // MARK: - Lifecycle
    
    init(api: APICallerDelegate = APICaller()) {
        self.api = api
    }
    
    // MARK: - Helper
    
    func uploadPost(caption: String, image: UIImage, completion: @escaping (Error?) -> Void) {
        api.uploadPost(caption: caption, image: image) { error in
            completion(error)
        }
    }
}
