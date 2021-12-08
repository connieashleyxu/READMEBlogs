//
//  SignInViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/13/21.
//

import UIKit

class SignInViewController: UITabBarController {

    //header
    private let headerView = SignInHeaderView()

    //email
    private let emailField: UITextField = {
        let field = UITextField()
        
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Email Address"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()

    //password
    private let passwordField: UITextField = {
        let field = UITextField()
        
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.leftViewMode = .always
        field.placeholder = "Password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        
        return field
    }()

    //sign in
    private let signInButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .systemBlue
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        
        return button
    }()

    //create acct
    private let createAccountButton: UIButton = {
        let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Sign In"
        
        view.backgroundColor = UIColor(red: 0.89, green: 0.85, blue: 0.48, alpha: 1.00)
        
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)

        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }

    //layout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/5)

        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width - 40, height: 50)
        signInButton.frame = CGRect(x: 125, y: passwordField.bottom + 30, width: view.width - 250, height: 50)
        createAccountButton.frame = CGRect(x: 20, y: signInButton.bottom + 40, width: view.width - 40, height: 50)
    }

    //did tap sign in btn
    @objc func didTapSignIn() {
        guard let email = emailField.text, !email.isEmpty, let password = passwordField.text, !password.isEmpty else {
            return
        }

        HapticsManager.shared.vibrateForSelection()

        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            guard success else {
                return
            }

            //update sub for new user
            IAPManager.shared.getSubscriptionStatus(completion: nil)

            DispatchQueue.main.async {
                UserDefaults.standard.set(email, forKey: "email")
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true)
            }
        }
    }

    //did tap create account btn
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
