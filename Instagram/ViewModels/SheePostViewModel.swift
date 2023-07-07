//
//  SheePostViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 30/1/23.
//

import Foundation
import UIKit

struct SheePostFormModel:Hashable {
    let iconImage: String
    let label: String
}


class SheePostViewModel {
    
    // MARK: - Porperties
    
    var postService: PostServiceDelegate
    
    var profileService: ProfileServiceDelegate
    
    var refreshData: ( () -> () )?

    var viewModel: [[ SheePostFormModel ]] = [[ SheePostFormModel ]]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Init
    
    init(
        postService: PostServiceDelegate = PostService(),
        profileService: ProfileServiceDelegate = ProfileService()
    ) {
        self.postService = postService
        self.profileService = profileService
    }
    
    // MARK: - Helpers
    
    func ShowSheeCurrentUser(completion: @escaping () -> Void ) {
        var arr_section01 = [SheePostFormModel]()
        var arr_section02 = [SheePostFormModel]()
        
        let section01: [SheePostFormModel] = [
            SheePostFormModel(iconImage: "bell.slash",label: "Desactivar notificaciones"),
            SheePostFormModel(iconImage: "pin",label: "Fijar en el perfil"),
            SheePostFormModel(iconImage: "circle.slash",label: "Desactivar comentarios"),
        ]
        
        let section02: [SheePostFormModel] = [
            SheePostFormModel(iconImage: "pencil",label: "Editar"),
            SheePostFormModel(iconImage: "trash",label: "Eliminar")
        ]
        
        // SECTION 01
        for item in section01 {
            let model = SheePostFormModel(
                iconImage: item.iconImage,
                label: item.label)
            arr_section01.append(model)
        }
        viewModel.append(arr_section01)
        
        // SECTION 02
        for item in section02 {
            let model = SheePostFormModel(
                iconImage: item.iconImage,
                label: item.label)
            arr_section02.append(model)
        }
        viewModel.append(arr_section02)
        
        completion()
    }
    
    
    func ShowSheeFollows(completion: @escaping () -> Void ) {
        var arr_section01 = [SheePostFormModel]()
        var arr_section02 = [SheePostFormModel]()
        
        let section01: [SheePostFormModel] = [
            SheePostFormModel(iconImage: "star",label: "Añadir a favoritos"),
            SheePostFormModel(iconImage: "person.badge.minus",label: "Dejar de seguir"),
        ]
        
        let section02: [SheePostFormModel] = [
            SheePostFormModel(iconImage: "info",label: "Información sobre la cuenta"),
            SheePostFormModel(iconImage: "exclamationmark.bubble",label: "Denunciar")
        ]
        
        // SECTION 01
        for item in section01 {
            let model = SheePostFormModel(
                iconImage: item.iconImage,
                label: item.label)
            arr_section01.append(model)
        }
        viewModel.append(arr_section01)
        
        // SECTION 02
        for item in section02 {
            let model = SheePostFormModel(
                iconImage: item.iconImage,
                label: item.label)
            arr_section02.append(model)
        }
        viewModel.append(arr_section02)
        
        completion()
    }
    
    func unfollow(uid: String, completion: @escaping(Error?)->Void) {
        profileService.unfollow(uid: uid, completion: { error in
            completion(error)
        })
    }
    
    func updateUserFeedAfterFollowing(user: User, didFollow: Bool) {
        postService.updateUserFeedAfterFollowing(user: user, didFollow: didFollow )
    }
    
    func deletePost(withPostId postId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        postService.deletePost(withPostId: postId) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let err):
                completion(.failure(err))
            }
        }
    }
    
    func numberOfSections() -> Int {
        return viewModel.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if viewModel[section].count != 0 {
            return viewModel[section].count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> SheePostFormModel {
        return viewModel[indexPath.section][indexPath.row]
    }
}
