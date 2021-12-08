//
//  CreateNewPostViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import Photos
import PhotosUI
import UIKit

class CreateNewPostViewController: UITabBarController {

    //title
    private let titleField: UITextField = {
        let field = UITextField()
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Title"
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()

    //img header
    private let headerImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo.on.rectangle")
        imageView.backgroundColor = .tertiarySystemBackground
        
        return imageView
    }()

    //text view
    private let textView: UITextView = {
        let textView = UITextView()
        
        textView.backgroundColor = .secondarySystemBackground
        textView.isEditable = true
//        textView.text = "Tell your story..."
//        textView.textColor = UIColor.lightGray
        textView.layer.cornerRadius = 8
        textView.font = .systemFont(ofSize: 18)
        
        return textView
    }()

    private var selectedHeaderImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerImageView)
        view.addSubview(textView)
        view.addSubview(titleField)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeader))
        headerImageView.addGestureRecognizer(tap)
        
        configureButtons()
    }

    //layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top, width: view.width - 20, height: 50)
        headerImageView.frame = CGRect(x: 0, y: titleField.bottom + 5, width: view.width, height: 200)
        textView.frame = CGRect(x: 10, y: headerImageView.bottom + 10, width: view.width - 20, height: view.height - 210 - view.safeAreaInsets.top)
    }
    
//    //for text view
//    @objc private func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//
//    @objc private func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    

    //did tap header img
    @objc private func didTapHeader() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        
        config.selectionLimit = 1
        config.filter = PHPickerFilter.images
        
        let vc = PHPickerViewController(configuration: config)
        vc.delegate = self
        
        present(vc, animated: true)
//        let picker = UIImagePickerController()
//
//        picker.sourceType = .photoLibrary
//        picker.delegate = self
//
//        present(picker, animated: true)
    }

    //configure
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .done,
            target: self,
            action: #selector(didTapCancel)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Post",
            style: .done,
            target: self,
            action: #selector(didTapPost)
        )
    }

    //did tap cancel btn
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    //did tap post btn
    @objc private func didTapPost() {
        //check data and post
        guard let title = titleField.text,
              let body = textView.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            //error if user did not complete all sections for blog
            let alert = UIAlertController(title: "Complete Your Blog", message: "Please enter a title, select an image, and write blog text to continue.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }

        print("starting post")

        let newPostId = UUID().uuidString

        //upload header img
        StorageManager.shared.uploadBlogHeaderImage(email: email, image: headerImage, postId: newPostId
        ) { success in
            guard success else {
                return
            }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newPostId) { url in
                guard let headerUrl = url else {
                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .error)
                    }
                    return
                }

                //insert post to database
                let post = BlogPost(identifier: newPostId, title: title, timestamp: Date().timeIntervalSince1970, headerImageUrl: headerUrl,
                    text: body
                )

                DatabaseManager.shared.insert(blogPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        DispatchQueue.main.async {
                            HapticsManager.shared.vibrate(for: .error)
                        }
                        return
                    }

                    DispatchQueue.main.async {
                        HapticsManager.shared.vibrate(for: .success)
                        self?.didTapCancel()
                    }
                }
            }
        }
    }
}

//extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//        guard let image = info[.originalImage] as? UIImage else {
//            return
//        }
//        selectedHeaderImage = image
//        headerImageView.image = image
//    }
//}

//img picker
extension CreateNewPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        results.forEach { result in
            result.itemProvider.loadObject(ofClass: UIImage.self)
            { reading, error in
                guard let image = reading as? UIImage, error == nil else {
                    return
                }
                print(image)
                self.selectedHeaderImage = image
                self.headerImageView.image = image
            }
        }
    }
}
