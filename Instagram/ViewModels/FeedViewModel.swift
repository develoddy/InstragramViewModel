//
//  HomeViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import Foundation
import Firebase

class FeedViewModel {
    
    // MARK: - Properties
    let api: APICallerDelegate
    
    
    // MARK: - Lifecycle
    
    init(api: APICallerDelegate = APICaller()) {
        self.api = api
    }
    
    // MARK: - Helpers
    
    func fetchPosts() {
        api.fetchPosts()
    }
    
}
