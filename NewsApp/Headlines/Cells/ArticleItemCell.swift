//
//  ArticleItemCell.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import UIKit
import Kingfisher
import RxSwift

class ArticleItemCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!

    var articleModel = ArticleModel() {
        willSet(article) {
            imageLoadingIndicator.startAnimating()

            self.avatarImageView.kf.setImage(with: URL(string: article.urlToImage ?? ""),
                                             placeholder: UIImage(named: "generic_user"),
                                             options: nil,
                                             progressBlock: nil) { [weak self] _ in
                self?.imageLoadingIndicator.stopAnimating()
            }
            self.titleLabel.text = article.title
            self.descriptionLabel.text = article.description
            self.timestampLabel.text = article.publishedAt?.timeAgoSinceNow()
        }
    }
}
