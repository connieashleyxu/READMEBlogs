//
//  SignUpViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import UIKit

class SignUpViewController: UITabBarController {

    //header
    private let headerView = SignInHeaderView()
    
    //name text field
    private let nameField: UITextField = {
        let field = UITextField()
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Full Name"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    //email text field
    private let emailField: UITextField = {
        let field = UITextField()
        
        field.keyboardType = .emailAddress
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email Address"
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    //password text field
    private let passwordField: UITextField = {
        let field = UITextField()
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()
    
    //sign in button
    private let signUpButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //view of screen
        title = "Create Account"
        
        view.backgroundColor = UIColor(red: 0.89, green: 0.85, blue: 0.48, alpha: 1.00)
        
//        load paywall view controller screen after 2 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
//            if !IAPManager.shared.isPremium() {
//                let vc = PayWallViewController()
//
//                let navVC = UINavigationController(rootViewController: vc)
//
//                self.present(navVC, animated: true, completion: nil)
//            }
//
//        }
        
        view.addSubview(headerView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
    }

    //layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)
        nameField.frame = CGRect(x: 20, y: headerView.bottom + 10, width: view.width - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: nameField.bottom + 10, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 10, width: view.width - 40, height: 50)
        signUpButton.frame = CGRect(x: 125, y: passwordField.bottom + 30, width: view.width - 250, height: 50)
    }
    
    //did tap sign up btn
    @objc func didTapSignUp() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let name = nameField.text, !name.isEmpty else {
                    return
                }
        
        HapticsManager.shared.vibrateForSelection()
        
        //create user
        AuthManager.shared.signUp(email: email, password: password) { [weak self] success in
            if success {
                //update database of user collection
                let newUser = User(name: name, email: email, profilePictureRef: nil)
                DatabaseManager.shared.insert(user: newUser) { inserted in
                    guard inserted else {
                        return
                    }
                    
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.set(name, forKey: "name")
                    
                    DispatchQueue.main.async {
                        let vc = UITabBarController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true)
                    }
                }
            } else {
                print("account creation fail")
            }
        }
    }
}
