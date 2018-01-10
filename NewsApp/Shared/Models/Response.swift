//
//  Response.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

// MARK: - Results
enum ApiResult<T> {
    case success(T)
    case failure(String)
    case unauthorized(String)
}

extension ApiResult: Error {}

typealias FeedResult = ApiResult<FeedResponse>
