//
//  PostPreviewTableViewCellViewModel.swift
//  XuConnieFinalProject
//
//  Created by Connie Xu on 12/1/21.
//


import Foundation
import UIKit

//table view for preview posts
class PostPreviewTableViewCellViewModel {
    let title: String
    let imageUrl: URL?
    var imageData: Data?

    init(title: String, imageUrl: URL?) {
        self.title = title
        self.imageUrl = imageUrl
    }
}

class PostPreviewTableViewCell: UITableViewCell {
    static let identifier = "PostPreviewTableViewCell"

    //blog post image
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
//        imageView.transform = imageView.transform.rotated(by: .pi/2)
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()

    //blog post title
    private let postTitleLabel: UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        contentView.backgroundColor = UIColor(red: 0.93, green: 0.92, blue: 0.81, alpha: 1.00)
        
        contentView.clipsToBounds = true
        
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        //circle half off
//        postImageView.frame = CGRect(x: separatorInset.left - 60, y: 5, width: contentView.height - 15, height: contentView.height - 15
//        )
        
        //circle on full
        postImageView.frame = CGRect(x: separatorInset.left, y: 5, width: contentView.height - 15, height: contentView.height - 15
        )
        postTitleLabel.frame = CGRect(x: postImageView.right + 15, y: 5, width: contentView.width - 5 - separatorInset.left - postImageView.width + 10, height: contentView.height - 10
        )
    }

    //resuse title and image
    override func prepareForReuse() {
        super.prepareForReuse()
        postTitleLabel.text = nil
        postImageView.image = nil
    }

    //configure view
    func configure(with viewModel: PostPreviewTableViewCellViewModel) {
        postTitleLabel.text = viewModel.title

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
