//
//  HomeViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 17/1/23.
//

import Foundation


class FeedViewModel {
    
    // MARK: - Properties
    let api: APICallerDelegate
    
    // MECANISMO PARA ENLAZAR LO QUE SERIA CON ESTE MODELO DE LA VISTA
    var refreshData: ( () -> () )?
    
    private var sections: [FeedSectionType] = [FeedSectionType]() {
        didSet {
            refreshData?()
        }
    }
    
    
    // MARK: - Lifecycle
    
    init(api: APICallerDelegate = APICaller()) {
        self.api = api
    }
    
    // MARK: - Helpers
    
    func fetchPosts() {
        // feed
        api.fetchPosts { [weak self] posts in
            self?.sections.append(.feeds(viewModels: posts.compactMap({
                //return FeedCollectionViewCellViewModel(caption: $0.caption, imageURL: $0.imageURL)
                return FeedCollectionViewCellViewModel(post: $0)
            })))
        }
        
        // call api
        // storie
        sections.append(.stories(viewModels: "-"))
    }
    
    func numberOfSections() -> Int {
        return self.sections.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        let type = sections[section]
        switch type {
        case .feeds(let viewModels):
            return viewModels.count
        case .stories(_):
            return 10
        }
    }
    
    func cellForRowAt(indexPath: IndexPath) -> FeedSectionType {
        return sections[indexPath.section]
    }
}
