//
//  UploadHistoryViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 9/2/23.
//

import UIKit

class UploadHistoryViewModel {
    
    // MARK: - Porperties
    
    let historyService: HistoryServiceDelegate
    
    // MARK: - Lifecycle
    
    init( historyService: HistoryServiceDelegate = HistoryService() ) {
        self.historyService = historyService
    }
    
    // MARK: - Helpers
    
    func uploadHistory( image: UIImage, currentUser: User, completion: @escaping (Error?) -> Void ) {
        historyService.uploadHistory(image: image, currentUser: currentUser) { error in
            completion(error)
        }
    }
}
