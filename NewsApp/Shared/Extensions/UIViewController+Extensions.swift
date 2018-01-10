//
//  UIViewController+Extensions.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/10/18.
//  Copyright © 2018 tungtm. All rights reserved.
//

import UIKit

extension UIViewController {
    func applyThemeColor() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = ThemeUtils.mainColor()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
    }
}
