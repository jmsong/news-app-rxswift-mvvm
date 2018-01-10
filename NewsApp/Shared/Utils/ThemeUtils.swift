//
//  ThemeUtils.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import UIKit

struct ThemeUtils {
    static func mainColor() -> UIColor {
        return UIColor(colorLiteralRed: 0/255.0,
                       green: 78/255.0,
                       blue: 117/255.0,
                       alpha: 1)
    }

    static func inactiveColor() -> UIColor {
        return UIColor(colorLiteralRed: 119/255.0,
                       green: 119/255.0,
                       blue: 119/255.0,
                       alpha: 1)
    }
}
