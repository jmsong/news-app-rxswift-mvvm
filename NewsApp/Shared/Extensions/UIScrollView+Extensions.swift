//
//  UIScrollView+Extensions.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 300.0) -> Bool {
        let innerEdgeOffset = contentSize.height * 0.5
        return self.contentOffset.y + self.frame.size.height + innerEdgeOffset > self.contentSize.height
    }
}
