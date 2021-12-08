//
//  PayWallDescriptionView.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 11/16/21.
//

import UIKit

class PayWallDescriptionView: UIView {

    //description label
    private let descriptorLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24, weight: .medium)
        label.numberOfLines = 0

        label.text = "Join README Premium to read unlimited articles!"

        return label
    }()

    //price label
    private let priceLabel: UILabel = {
        let label = UILabel()

        //TODO: layout edit
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.numberOfLines = 1

        label.text = "$4.99 / month"

        return label
    }()

    override init(frame: CGRect){
        super.init(frame: frame)
        clipsToBounds = true

        addSubview(descriptorLabel)
        addSubview(priceLabel)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //layout subview
    override func layoutSubviews() {
        super.layoutSubviews()

        descriptorLabel.frame = CGRect(x: 20, y: 0, width: width - 40, height: height/2)
        priceLabel.frame = CGRect(x: 20, y: height/2 + 20, width: width - 40, height: height/2)
    }
}
