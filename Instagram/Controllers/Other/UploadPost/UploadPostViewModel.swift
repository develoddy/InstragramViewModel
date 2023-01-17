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
    
    let uploadPostService : UploadPostServiceDelegate
    
    
    // MARK: - Lifecycle
    
    init(uploadPostService: UploadPostServiceDelegate = UploadPostService()) {
        self.uploadPostService = uploadPostService
    }
    
    // MARK: - Helper
    
    func uploadPost(caption: String, image: UIImage, completion: @escaping (Error?) -> Void) {
        uploadPostService.uploadPost(caption: caption, image: image) { error in
            completion(error)
        }
    }
}
