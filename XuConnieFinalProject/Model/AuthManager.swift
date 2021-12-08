//
//  AuthManager.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import Foundation
import FirebaseAuth

final class AuthManager{
    static let shared = AuthManager()

    private let auth = Auth.auth()

    private init() {}

    //check if user is signed in
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }

    //sign up user if no account
    public func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
                  return
              }

        auth.createUser(withEmail: email, password: password) {
            result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }

            //account created
            completion(true)
        }
    }

    //sign in user
    public func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6 else {
                  return
              }

        auth.signIn(withEmail: email, password: password) {
            result, error in
            guard result != nil, error == nil else {
                completion(false)
                return
            }

            completion(true)
        }
    }

    //sign out user
    public func signOut(completion: (Bool) -> Void) {
        do {
            try auth.signOut()
            completion(true)
        }
        catch {
            print("error signing out")
            print(error)
            completion(false)
        }
    }
}
