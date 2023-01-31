//
//  SheePostViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 30/1/23.
//

import Foundation

struct SheePostFormModel:Hashable {
    let iconImage: String
    let label: String
}


class SheePostViewModel {
    
    // MARK: - Porperties
    
    var postService: PostServiceDelegate
    
    var refreshData: ( () -> () )?

    var viewModel: [[ SheePostFormModel ]] = [[ SheePostFormModel ]]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - Init
    
    init(
        postService: PostServiceDelegate = PostService()
    ) {
        self.postService = postService
    }
    
    // MARK: - Helpers
    
    //func fetchData(completion: @escaping ([[SheePostFormModel]]) -> Void ) {
    func fetchData(completion: @escaping () -> Void ) {
        
        var arr_section01 = [SheePostFormModel]()
        var arr_section02 = [SheePostFormModel]()
        
        let section01: [SheePostFormModel] = [
            SheePostFormModel(iconImage: "bell.slash",label: "Desactivar notificaciones"),
            SheePostFormModel(iconImage: "pin",label: "Fijar en el perfil"),
            SheePostFormModel(iconImage: "clock",label: "Archivar"),
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
    
    func updatePost(post: Post, completion: @escaping () -> Void ) {
        /*postService.updatePost(post: post) {
            completion()
        }*/
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
