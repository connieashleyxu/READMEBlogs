//
//  PayWallHeaderView.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/16/21.
//

import UIKit

class PayWallHeaderView: UIView {

    //header img
    private let headerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "wand.and.stars.inverse"))

        imageView.frame = CGRect(x: 0, y:0, width: 90, height: 90)

        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    //init image header and background color
    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = true
        addSubview(headerImageView)

        backgroundColor =  UIColor(red: 0.89, green: 0.85, blue: 0.48, alpha: 1.00)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //centered layout of crown
    override func layoutSubviews() {
        super.layoutSubviews()
        //not centered
        //headerImageView.center = center

        //centered
        headerImageView.frame = CGRect(x: (bounds.width - 90)/2, y: (bounds.height - 90)/2, width: 90, height: 90)
    }
}
