//
//  StoriesCollectionReusableViewViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 8/2/23.
//

import Foundation

struct StoryCollectionViewCellViewModel {
    var history: History
    
    var imageURL: URL? { return URL(string: history.imageURL)}
        
    var username: String { return history.ownerUsername }

    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .full
        return formatter.string(from: history.timestamp.dateValue(), to: Date())
    }
    
    init(history: History) {
        self.history = history
    }
}
