//
//  ProfileViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

//profile photo, name, email, posts
import Photos
import PhotosUI
import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var user: User?

    private let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        
        return tableView
    }()

    let currentEmail: String

    init(currentEmail: String) {
        self.currentEmail = currentEmail
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSignOutButton()
        setUpTable()
        
        title = "Profile"
        
        view.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.81, alpha: 1.00)
        
        fetchPosts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }

    private func setUpTable() {
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpTableHeader()
        fetchProfileData()
    }

    private func setUpTableHeader(profilePhotoRef: String? = nil, name: String? = nil) {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width/1.5))
        
        headerView.backgroundColor = UIColor(red: 0.89, green: 0.85, blue: 0.48, alpha: 1.00)
        
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        tableView.tableHeaderView = headerView

        //profile photo
        let profilePhoto = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePhoto.tintColor = .black
        profilePhoto.contentMode = .scaleAspectFit
        profilePhoto.frame = CGRect(x: (view.width-(view.width/4))/2, y: (headerView.height-(view.width/4))/2.5, width: view.width/4, height: view.width/4
        )
        
        profilePhoto.layer.masksToBounds = true
        profilePhoto.layer.cornerRadius = profilePhoto.width/2
        profilePhoto.isUserInteractionEnabled = true
        headerView.addSubview(profilePhoto)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profilePhoto.addGestureRecognizer(tap)

        //email
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePhoto.bottom + 10, width: view.width - 40, height: 100))
        headerView.addSubview(emailLabel)
        emailLabel.textAlignment = .center
        emailLabel.textColor = .black
        emailLabel.font = .systemFont(ofSize: 20, weight: .bold)

        //tab bar and title is user name
//        if let name = name {
//            title = "name"
//        }
        
        //greeting of user's name
        emailLabel.text = "Hello, \(name ?? "Profile")"
            
        if let ref = profilePhotoRef {
            //fetch image
            print("photo ref: \(ref)")
            StorageManager.shared.downloadUrlForProfilePicture(path: ref) { url in
                guard let url = url else {
                    return
                }
                let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                    guard let data = data else {
                        return
                    }
                    DispatchQueue.main.async {
                        profilePhoto.image = UIImage(data: data)
                    }
                }
                task.resume()
            }
        }
    }

    //another method of pic import
    //did tap photo to add in image
    @objc private func didTapProfilePhoto() {
        print("did tap profile photo")
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail == currentEmail else {
            return
        }

        let picker = UIImagePickerController()
        
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
        
        //photokit
//        var config = PHPickerConfiguration(photoLibrary: .shared())
//
//        config.selectionLimit = 1
//        config.filter = PHPickerFilter.images
//
//        let vc = PHPickerViewController(configuration: config)
//        vc.delegate = self
//
//        present(vc, animated: true)
    }

    private func fetchProfileData() {
       
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else {
                return
            }
            self?.user = user

            DispatchQueue.main.async {
                self?.setUpTableHeader(
                    profilePhotoRef: user.profilePictureRef,
                    name: user.name
                )
            }
        }
    }

    //sign out
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut)
        )
    }

    //func to sign out
    @objc private func didTapSignOut() {
        let sheet = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "email")
                        UserDefaults.standard.set(nil, forKey: "name")
                        UserDefaults.standard.set(false, forKey: "premium")

                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always

                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(sheet, animated: true)
    }

    //table view
    private var posts: [BlogPost] = []

    //get post
    private func fetchPosts() {
        print("fetching posts")

        DatabaseManager.shared.getPosts(for: currentEmail) { [weak self] posts in
            self?.posts = posts
            print("found \(posts.count) posts")
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

        var isOwnedByCurrentUser = false
        if let email = UserDefaults.standard.string(forKey: "email") {
            isOwnedByCurrentUser = email == currentEmail
        }

        if !isOwnedByCurrentUser {
            //user can always view own posts in profile vc
            if IAPManager.shared.canViewPost {
                let vc = ViewPostViewController(
                    post: posts[indexPath.row],
                    isOwnedByCurrentUser: isOwnedByCurrentUser
                )
                vc.navigationItem.largeTitleDisplayMode = .never
                vc.title = "Post"
                navigationController?.pushViewController(vc, animated: true)
            }
            else {
                let vc = PayWallViewController()
                present(vc, animated: true)
            }
        }
        else {
            //our post
            let vc = ViewPostViewController(
                post: posts[indexPath.row],
                isOwnedByCurrentUser: isOwnedByCurrentUser
            )
            vc.navigationItem.largeTitleDisplayMode = .never
            vc.title = "Post"
            navigationController?.pushViewController(vc, animated: true)

        }
    }

}

//image picker delegates
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else {
            return
        }

        StorageManager.shared.uploadUserProfilePicture(
            email: currentEmail,
            image: image
        ) { [weak self] success in
            guard let strongSelf = self else { return }
            if success {
                //update database
                DatabaseManager.shared.updateProfilePhoto(email: strongSelf.currentEmail) { updated in
                    guard updated else {
                        return
                    }
                    DispatchQueue.main.async {
                        strongSelf.fetchProfileData()
                    }
                }
            }
        }
    }
}
