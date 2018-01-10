//
//  ArticleModel.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

struct FeedResponse: Mappable {
    var status: String = ""
    var totalResults: Int?
    var articles: [ArticleModel] = []

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        status <- map["status"]
        totalResults <- map["totalResults"]
        articles <- map["articles"]
    }
}

struct ArticleModel: Mappable {
    var sourceId: String?
    var sourceName: String?
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?

    init() {}

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        sourceId <- map["source.id"]
        sourceName <- map["source.name"]
        author <- map["author"]
        title <- map["title"]
        description <- map["description"]
        url <- map["url"]
        urlToImage <- map["urlToImage"]
        publishedAt <- map["publishedAt"]
    }
}

// MARK: Equatable
extension ArticleModel: Equatable {}

func == (lhs: ArticleModel, rhs: ArticleModel) -> Bool {
    return lhs.sourceId == rhs.sourceId
}


// MARK:- [Realm] ArticleObject
class ArticleEntity: Object {
    dynamic var sourceId: String = ""
    dynamic var sourceName: String = ""
    dynamic var author: String = ""
    dynamic var title: String = ""
    dynamic var articleDescription: String = ""
    dynamic var url: String = ""
    dynamic var urlToImage: String = ""
    dynamic var publishedAt: String = ""

    override static func primaryKey() -> String? {
        return "title"
    }
}
