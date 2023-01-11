//
//  ViewController.swift
//  Instagram
//
//  Created by Eddy Donald Chinchay Lujan on 4/1/23.
//

import UIKit
import Firebase
//import FirebaseCore

class TabBarViewController: UITabBarController {
    
    var handle: AuthStateDidChangeListenerHandle?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        //let email = AuthManager.shared.fetchEmaillLoginUser()
        //configureViewControllers(with: user)
        //print("debug: \(email)")
        APICaller.shared.fetchUserLogin { [weak self] result in
            switch result {
            case .success(let user):
                self?.configureViewControllers(with: user)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
    
    func configureViewControllers(with user: User) {
        let vc1 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "house")!,
            selectedImage: UIImage(systemName: "house.fill")!,
            rootViewController: HomeViewController()
        )
        
        let vc2 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "magnifyingglass")!,
            selectedImage: UIImage(systemName: "magnifyingglass.circle.fill")!,
            rootViewController: SearchViewController()
        )
        
        let vc3 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "bell")!,
            selectedImage: UIImage(systemName: "bell.fill")!,
            rootViewController: NotificationViewController()
        )
        
        
        let vc4 = templateNavigationController(
            unSelectedImage: UIImage(systemName: "person")!,
            selectedImage: UIImage(systemName: "person.fill")!,
            rootViewController: ProfileViewController(user: user)
        )
        
        vc1.title = "Feed"
        vc2.title = "Search"
        vc3.title = "Notification"
        vc4.title = "Profile"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        vc4.navigationItem.largeTitleDisplayMode = .always
        
        vc1.navigationBar.prefersLargeTitles = true
        vc2.navigationBar.prefersLargeTitles = true
        vc3.navigationBar.prefersLargeTitles = true
        vc4.navigationBar.prefersLargeTitles = true
        
        vc1.navigationBar.tintColor = .label
        vc2.navigationBar.tintColor = .label
        vc3.navigationBar.tintColor = .label
        vc4.navigationBar.tintColor = .label
        
        setViewControllers([vc2, vc1, vc3, vc4], animated: false)
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

}

