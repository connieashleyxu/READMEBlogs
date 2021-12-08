//
//  PayWallViewController.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/14/21.
//

import UIKit


class PayWallViewController: UIViewController {

    //instance of views
    private let header = PayWallHeaderView()
    private let heroView = PayWallDescriptionView()

    //header img
//    private let headerImageView: UIImageView = {
//        let imageView = UIImageView(image: UIImage(systemName: "crown.fill"))
//        imageView.tintColor = .white
//        imageView.contentMode = .scaleAspectFit
//        return imageView
//    }()

    //cta buttons
    //subscribe
    private let buyButton: UIButton = {
        let button = UIButton()

        button.setTitle("Subscribe", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true

        return button
    }()

    //restore
    private let restoreButton: UIButton = {
        let button = UIButton()

        button.setTitle("Restore Purchase", for: .normal)
        //button.backgroundColor = .systemBlue
        button.setTitleColor(.link, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true

        return button
    }()

    //terms
    private let termsView: UITextView = {
        let textView = UITextView()

        textView.isEditable = false

        textView.textAlignment = .center
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 14)
        textView.text = "This subscription automatically renews for $4.99 a month. You can cancel anytime. By signing up, you agree to README's Terms of Service and Privacy Policy."

        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "README Premium"

        view.backgroundColor = .systemBackground

        view.addSubview(header)
        view.addSubview(buyButton)
        view.addSubview(restoreButton)
        view.addSubview(termsView)
        view.addSubview(heroView)

        setUpCloseButton()
        setUpButtons()
        
        //heroView.backgroundColor = .systemGray
    }

    //view subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        header.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/3.2)

        termsView.frame = CGRect(x: 10, y: view.height - 100, width: view.width - 20, height: 100)

        restoreButton.frame = CGRect(x: 25, y: termsView.top - 70, width: view.width - 50, height: 50)

        buyButton.frame = CGRect(x: 25, y: restoreButton.top - 60, width: view.width - 50, height: 50)

        heroView.frame = CGRect(x: 0, y: header.bottom, width: view.width, height: buyButton.top - view.safeAreaInsets.top - header.height)
    }

    //set up cta buttons
    private func setUpButtons() {
        buyButton.addTarget(self, action: #selector(didTapSubscribe), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestore), for: .touchUpInside)
    }

    //set up close button
    private func setUpCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    }

    //user did tap cta button subscribe
    @objc private func didTapSubscribe(){
        print("did tap sub")
        
        //revenue cat
        IAPManager.shared.fetchPackages { package in
            guard let package = package else {
                print("entered test subscripe tap error")
                return
            }

            
            IAPManager.shared.subscribe(package: package) { [weak self] success in
                print("purchase: \(success)")

                DispatchQueue.main.async {
                    //print("did tap sub entered")
                    if success {
                        self?.dismiss(animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Subscription Failed", message: "Unable to complete the transaction.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
    }

    //user did tap cta button restore purchases
    @objc private func didTapRestore(){
        //revenue cat
        IAPManager.shared.restorePurchases { [weak self] success in
            print("restored: \(success)")

            DispatchQueue.main.async {
                if success {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Restoration Failed", message: "Unable to restore a previous transaction.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    //user did tap close pay wall
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
