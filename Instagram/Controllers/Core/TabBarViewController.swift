//
//  ViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit
import Firebase
import YPImagePicker

class TabBarViewController: UITabBarController {
    
    var handle: AuthStateDidChangeListenerHandle?
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            self.configureViewControllers(with: user)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { [weak self] result in
            switch result {
            case .success(let user):
                print(user)
                self?.user = user
            case .failure(let error):
                print("DEBUG: TabBAR \(error.localizedDescription)")
                print(error.localizedDescription)
            }
        }
    }
    
    func configureViewControllers(with user: User) {
        
        self.delegate = self
        
        let vc1 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "house")!,
            selectedImage: UIImage(systemName: "house.fill")!,
            rootViewController: FeedViewController()
        )
        
        let vc2 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "magnifyingglass")!,
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")!,
            rootViewController: SearchViewController()
        )
        
        let vc3 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "plus.app")!,
            selectedImage: UIImage(systemName: "plus.app.fill")!,
            rootViewController: ImageSelectorViewController()
        )
        
        let vc4 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "heart")!,
            selectedImage: UIImage(systemName: "heart.fill")!,
            rootViewController: NotificationViewController()
        )
        
        
        let vc5 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "person")!,
            selectedImage: UIImage(systemName: "person.fill")!,
            rootViewController: ProfileViewController(user: user)
        )
        
        vc1.title = "Feed"
        vc2.title = "Search"
        vc3.title = "Create"
        vc4.title = "Notification"
        vc5.title = "Profile"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        vc5.navigationItem.largeTitleDisplayMode = .always
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
        vc4.navigationBar.prefersLargeTitles = true
        vc5.navigationBar.prefersLargeTitles = true
        
        vc1.navigationBar.tintColor = .label
        vc2.navigationBar.tintColor = .label
        vc3.navigationBar.tintColor = .label
        vc4.navigationBar.tintColor = .label
        vc5.navigationBar.tintColor = .label
        
        setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
    }
    
    // MARK: - Helpers
    
    func templateNavigationController(unSelectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController  {
        let nav = UINavigationController(
            rootViewController: rootViewController
        )
        nav.tabBarItem.image = unSelectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPickingMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, cancelled in
            picker.dismiss(animated: true)
            guard let selectedImage = items.singlePhoto?.image else {
                return
            }
            let vc = UploadPostViewController()
            vc.selectedimage = selectedImage
            vc.delegate = self
            vc.currentUser = self.user
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
        }
    }
}


// MARK: - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            self.didFinishPickingMedia(picker)
        }
        return true
    }
}


// MARK: - UploadPostViewControllerDelegate

extension TabBarViewController: UploadPostViewControllerDelegate {
    func uploadPostViewControllerDidFinishUploadingPost(_ controller: UploadPostViewController) {
        selectedIndex = 0
        controller.dismiss(animated: true, completion: nil)
        
        guard let feedNav = viewControllers?.first as? UINavigationController else { return }
        guard let feed = feedNav.viewControllers.first as? FeedViewController else { return }
        feed.handleRefresh()
    }
}
