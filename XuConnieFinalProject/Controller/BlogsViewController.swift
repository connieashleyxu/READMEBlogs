//
//  ViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import UIKit

class BlogsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //make new post button
    private let composeButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .medium)) , for: .normal)
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        
        return button
    }()
    
    //table view of blogs
    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        //view of screen
        view.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.81, alpha: 1.00)
        
        view.addSubview(tableView)
        view.addSubview(composeButton)
        
        composeButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchAllPosts()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        composeButton.frame = CGRect(x: view.frame.width - 88, y: view.frame.height - 88 - view.safeAreaInsets.bottom, width: 60, height: 60)
        
        tableView.frame = view.bounds
    }
    
    //did tap create post
    @objc private func didTapCreate() {
        let vc = CreateNewPostViewController()
        
        vc.title = "Create Post"
        
        let navVc = UINavigationController(rootViewController: vc)
        
        present(navVc, animated: true)
    }
    
    //collection of posts
    private var posts: [BlogPost] = []
    
    //get all posts for feed
    private func fetchAllPosts() {
        print("fetching blog feed")

        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    //table view delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell else {
            fatalError()
        }
        cell.configure(with: .init(title: post.title, imageUrl: post.headerImageUrl))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        HapticsManager.shared.vibrateForSelection()

        //user can view post unless exceed amount for free version
        guard IAPManager.shared.canViewPost else {
            print("can view post exceeded")
            let vc = PayWallViewController()
            present(vc, animated: true, completion: nil)
            return
        }

        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Post"
        navigationController?.pushViewController(vc, animated: true)
    }
}
