//
//  SignInHeaderView.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/29/21.
//

import UIKit

//sign in to user
class SignInHeaderView: UIView {

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))

        
        imageView.contentMode = .scaleAspectFit
        
        imageView.backgroundColor = UIColor(red: 0.89, green: 0.85, blue: 0.48, alpha: 1.00)

        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .black)
        label.text = "README"

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true

        addSubview(label)
        addSubview(imageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //subview layout
    override func layoutSubviews() {
        super.layoutSubviews()

        let size: CGFloat = width/4
        imageView.frame = CGRect(x: (width - size)/2, y: 10, width: size, height: size)
        label.frame = CGRect(x: 20, y: imageView.bottom, width: width - 40, height: height - size - 30)
    }
}
