//
//  StorageManager.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import Foundation
import FirebaseStorage

final class StorageManager{
    static let shared = StorageManager()

    private let container = Storage.storage()

    private init() {}

    //upload user profile pic
    public func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void) {
        let path = email.replacingOccurrences(of: "@", with: "_")
                        .replacingOccurrences(of: ".", with: "_")

        guard let pngData = image?.pngData() else {
            return
        }

        container
            .reference(withPath: "profile_pictures/\(path)/photo.png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    //print("error in save prof pic")
                    return
                }
                completion(true)
            }
    }

    //download URL for profile pic
    public func downloadUrlForProfilePicture(path: String, completion: @escaping (URL?) -> Void){
        container.reference(withPath: path)
            .downloadURL { url, _ in
            completion(url)
        }
    }

    //upload blog header
    public func uploadBlogHeaderImage(email: String, image: UIImage, postId: String, completion: @escaping (Bool) -> Void) {
        let path = email.replacingOccurrences(of: "@", with: "_")
                        .replacingOccurrences(of: ".", with: "_")

        guard let pngData = image.pngData() else {
            return
        }

        container.reference(withPath: "posts_headers/\(path)/\(postId).png")
            .putData(pngData, metadata: nil) { metadata, error in
                guard metadata != nil, error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }

    //download blog header
    public func downloadUrlForPostHeader(email: String, postId: String, completion: @escaping (URL?) -> Void){
        let emailComponent = email.replacingOccurrences(of: "@", with: "_")
                        .replacingOccurrences(of: ".", with: "_")

        container.reference(withPath: "posts_headers/\(emailComponent)/\(postId).png")
            .downloadURL { url, _ in
                completion(url)
            }
    }
}
