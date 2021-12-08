//
//  TabBarViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpControllers()
    }

    //sets up views of main pages (blogs page + profile page)
    private func setUpControllers() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else {
            AuthManager.shared.signOut { _ in
                
            }
            return
        }

        let blogs = BlogsViewController()
        blogs.title = "Blogs"

        let profile = ProfileViewController(currentEmail: currentUserEmail)
        profile.title = "Profile"

        blogs.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always

        let nav1 = UINavigationController(rootViewController: blogs)
        let nav2 = UINavigationController(rootViewController: profile)

        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true

        nav1.tabBarItem = UITabBarItem(title: "Blogs", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)

        setViewControllers([nav1, nav2], animated: true)
    }
}
