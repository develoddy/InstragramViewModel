//
//  EditProfileViewModel.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 1/2/23.
//

import Foundation



class EditProfileViewModel {
    
    // MARK: - Properties

    var refreshData: ( () -> () )?
    
    var user: User? {
        didSet {
            self.refreshData?()
        }
    }

    var models: [[ FormEditProfileTableViewCellViewModel ]] = [[ FormEditProfileTableViewCellViewModel ]]() {
        didSet {
            self.refreshData?()
        }
    }
    
    // MARK: - lifecycle
    
    init() {}
    
    // MARK: - helpers

    func fetchData(uid: String, completion: @escaping() -> Void ) {
        UserService.shared.fetchUser(uid: uid) { result in
            switch result {
            case .success(let user):
                self.user = user
                var section1 = [FormEditProfileTableViewCellViewModel]()
                section1.append(FormEditProfileTableViewCellViewModel(label: "Name", placeHolder: "Enter name", value: user.fullname ))
                section1.append(FormEditProfileTableViewCellViewModel(label: "Username", placeHolder: "Enter username", value: user.username ))
                section1.append(FormEditProfileTableViewCellViewModel(label: "Bio", placeHolder: "Enter bio", value: user.username ))
                self.models.append(section1)
                
                var section2 = [FormEditProfileTableViewCellViewModel]()
                section2.append(FormEditProfileTableViewCellViewModel(label: "Email", placeHolder: "Enter email", value: user.email ))
                section2.append(FormEditProfileTableViewCellViewModel(label: "Phone", placeHolder: "Enter phone", value: "+34605974436" ))
                section2.append(FormEditProfileTableViewCellViewModel(label: "Gender", placeHolder: "Enter gender", value: "hombre" ))
                self.models.append(section2)
                
                completion()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
    
    func numberOfSections() -> Int {
        return models.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if models[section].count != 0 {
            return models[section].count
        }
        return 0
    }
    
    func cellForRowAt(indexPath: IndexPath) -> FormEditProfileTableViewCellViewModel {
        return models[indexPath.section][indexPath.row]
    }
}
