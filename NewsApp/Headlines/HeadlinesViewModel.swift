//
//  HeadlinesViewModel.swift
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Moya
import Moya_ObjectMapper

class HeadlinesViewModel: NSObject {

    private let disposeBag = DisposeBag()
    var next = Variable<Int>(1)

    var items = Variable<[ArticleModel]>([])
    var itemsObs: Observable<[ArticleModel]>

    var requestPull = PublishSubject<Void>()

    var internetStatus = Variable<Bool>(true)
    let internet: Observable<Bool>

    let requestingPull: Observable<Bool>

    var pullFinished: Observable<FeedResult>

    override init() {
        itemsObs = items.asObservable()

        let internetValid = internetStatus.asObservable().shareReplay(1)
        internet = requestPull.withLatestFrom(internetValid).shareReplay(1)

        let activityIndicator = ActivityIndicator()
        requestingPull = activityIndicator.asObservable().observeOn(MainScheduler.instance).shareReplay(1)

        pullFinished = Observable.empty()

        super.init()

        pullFinished = requestPull.observeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ [unowned self] in
                self.fetchArticles(activityIndicator: activityIndicator)
            }).map({ [weak self] result in
                self?.fill(result: result, needToReload: true)
                return result
            })
    }

    private func fetchArticles(activityIndicator: ActivityIndicator) -> Observable<FeedResult> {
        return DataStoreManager.shared.fetchHeadlines(sources: "bbc-news")
            .trackActivity(activityIndicator).observeOn(MainScheduler.instance)
    }

    private func fill(result: FeedResult, needToReload reload: Bool) {

        func fillResult(response: FeedResponse) {
            if reload {
                self.items.value.removeAll()
            }

            for article in response.articles {
                self.items.value.append(article)
            }

            /*
             * Do filtering duplicated items
             */
            let filteredItems = items.value.filterDuplicates { $0.0.title == $0.1.title }
            items.value = filteredItems
        }

        switch result {
        case .success(let response):
            fillResult(response: response)
        default:
            break
        }
    }

    func item(at row: Int) -> ArticleModel {
        return items.value[row]
    }
}
