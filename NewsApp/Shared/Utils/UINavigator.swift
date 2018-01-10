//
//  UINavigator.swift
//  KApp
//
//  Created by KApp Dev on 5/30/17.
//  Copyright © 2017 Larvol. All rights reserved.
//

import UIKit

struct UINavigator {
    private static let storyboard = UIStoryboard(name: "Main", bundle: nil)

    static func navigateToWebView(newsUrl: String?) {
        let nav = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController

        let newsDetailVC = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController")
            as? NewsDetailViewController
        newsDetailVC?.title = NSURL(string: newsUrl ?? "")?.host
        newsDetailVC?.newsUrl = newsUrl
        nav?.pushViewController(newsDetailVC!, animated: true)
    }
}
