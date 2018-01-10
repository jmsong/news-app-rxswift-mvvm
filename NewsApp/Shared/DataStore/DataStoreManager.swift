//
//  DataStoreManager.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import Moya
import Moya_ObjectMapper
import RxSwift

// MARK: - Main
class DataStoreManager {
    static let shared = DataStoreManager()
    fileprivate let disposeBag = DisposeBag()

    func transformsError<T>(error: Swift.Error) -> Observable<ApiResult<T>> {
        let result = error as? ApiResult<Response>

        guard let unwrapResult = result else {
            return Observable.just(ApiResult<T>.failure(Localizer.something_wrong.description))
        }

        switch unwrapResult {
        case .unauthorized(let msg):
            return Observable.just(ApiResult<T>.unauthorized(msg))
        default:
            return Observable.just(ApiResult<T>.failure(Localizer.something_wrong.description))
        }
    }
}

// MARK: - Categories
extension DataStoreManager {
    func fetchHeadlines(sources: String) -> Observable<FeedResult> {
            if ConnectionStatus.isInternetAvailable() {
                return NewsAppProvider.request(.fetchHeadlines(sources))
                    .filterSuccessCases()
                    .map({ response in
                        var failed = false
                        var feedResponse = FeedResponse()
                        var errorMsg = ""
                        do {
                            feedResponse = try response.mapObject(FeedResponse.self)
                            DatabaseManager.shared.clearArticles()

                            // insert trials array into database
                            DatabaseManager.shared.insert(articleList: feedResponse.articles)
                        } catch(let err) {
                            errorMsg = err.localizedDescription
                            LOGGER.error("error: \(errorMsg)")
                            failed = true
                        }

                        if failed {
                            return FeedResult.failure(errorMsg)
                        } else {
                            return FeedResult.success(feedResponse)
                        }
                    }).catchError({ [weak self] error -> Observable<FeedResult> in
                        return (self?.transformsError(error: error))!
                    })
            } else {
                return headlinesFromRealm()
            }
    }

    private func headlinesFromRealm() -> Observable<FeedResult> {
        return Observable<FeedResult>.create { observer in
            var feedResponse = FeedResponse()
            feedResponse.status = "ok"
            feedResponse.articles = DatabaseManager.shared.allArticles()
            
            observer.onNext(FeedResult.success(feedResponse))
            observer.onCompleted()
            return Disposables.create()
            }.subscribeOn(MainScheduler.instance)
    }
}
