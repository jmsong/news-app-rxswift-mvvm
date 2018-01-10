//
//  UITableView+Extensions.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func empty(message: String) {
        let messageLabel = UILabel(frame:
            CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.darkGray
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 17)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.backgroundView?.isHidden = true
    }

    func showEmpty() {
        self.backgroundView?.isHidden = false
    }

    func hideEmpty() {
        self.backgroundView?.isHidden = true
    }
}
