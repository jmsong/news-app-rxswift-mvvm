//
//  UIUtils.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/10/18.
//  Copyright © 2018 tungtm. All rights reserved.
//

import Whisper

struct UIUtils {
    static func showError(message: String) {
        let murmur = Murmur(title: message)
        
        // Show and hide a message after delay
        Whisper.show(whistle: murmur, action: .show(2.0))
    }
    
    static func showIndicator(executing: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = executing
    }
}
