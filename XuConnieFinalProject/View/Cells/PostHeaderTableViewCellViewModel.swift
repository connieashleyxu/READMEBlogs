//
//  PostHeaderTableViewCellViewModel.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 12/1/21.
//


import Foundation
import UIKit

//heder layout view table
class PostHeaderTableViewCellViewModel {
    let imageUrl: URL?
    var imageData: Data?

    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    static let identifier = "PostHeaderTableViewCell"

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
//        imageView.transform = imageView.transform.rotated(by: .pi/2)
        
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    //layout of header when in post
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }

    //prepare to reuse view
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }

    //configure view
    func configure(with viewModel: PostHeaderTableViewCellViewModel) {
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageUrl {
            //fetch image and cache
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let data = data else {
                    return
                }

                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }
            task.resume()
        }
    }
}
