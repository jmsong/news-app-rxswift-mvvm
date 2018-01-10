//
//  DatabaseManager.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import RealmSwift

extension Results {
    func toArray() -> [T] {
        return self.map {$0}
    }
}

extension RealmSwift.List {
    func toArray() -> [T] {
        return self.map {$0}
    }
}

// MARK: - Admin functions
class DatabaseManager {
    static let shared = DatabaseManager()

    private init() {}

    func upgradeIfNeeded() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 0,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above

            migrationBlock: { _, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                }
        })
        Realm.Configuration.defaultConfiguration = config
    }

    func clearArticles() {
        let realm = try? Realm()
        if let articlesFromRealm = realm?.objects(ArticleEntity.self) {
            do {
                try realm?.write {
                    realm?.delete(articlesFromRealm)
                }
            } catch(let e) {
                LOGGER.error("[DatabaseManager] clearArticles exception: \(e.localizedDescription)")
            }
        }
    }

    func insert(articleList: [ArticleModel]) {
        let realm = try? Realm()
        do {
            try realm?.write {
                for aNews in articleList {
                    let news = ArticleEntity()
                    news.sourceId = aNews.sourceId ?? ""
                    news.sourceName = aNews.sourceName ?? ""
                    news.author = aNews.author ?? ""
                    news.title = aNews.title ?? ""
                    news.articleDescription = aNews.description ?? ""
                    news.url = aNews.url ?? ""
                    news.urlToImage = aNews.urlToImage ?? ""
                    news.publishedAt = aNews.publishedAt ?? ""

                    realm?.add(news, update: true)
                }
            }
        } catch(let e) {
            LOGGER.error("[DatabaseManager] insertNewsList exception: \(e.localizedDescription)")
        }
    }

    func allArticles() -> [ArticleModel] {
        let realm = try? Realm()
        guard let articlesResult = realm?.objects(ArticleEntity.self).toArray() else {
                LOGGER.error("allArticles return empty!!!")
                return []
        }

        var articleArr = [ArticleModel]()
        for aNews in articlesResult {
            var news = ArticleModel()
            news.sourceId = aNews.sourceId
            news.sourceName = aNews.sourceName
            news.author = aNews.author
            news.title = aNews.title
            news.description = aNews.articleDescription
            news.url = aNews.url
            news.urlToImage = aNews.urlToImage
            news.publishedAt = aNews.publishedAt

            articleArr.append(news)
        }

        return articleArr
    }
}
