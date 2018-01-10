//
//  PullLoadMoreApplicable.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

var refresherHandle: UInt8 = 0
var isLoadingHandle: UInt8 = 0
var loadingViewHandle: UInt8 = 0
var loadingIndicatorHandle: UInt8 = 0

func associatedObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

protocol PullApplicable {
}

protocol LoadMoreApplicable: class {
}

extension PullApplicable where Self: UIViewController {
    var refresher: UIRefreshControl {
        return associatedObject(base: self, key: &refresherHandle, initialiser: { () -> UIRefreshControl in
            return UIRefreshControl()
        })
    }

    func rx_refresher(forTableView tableView: UITableView,
                      withControlEvent event: PublishSubject<Void>,
                      withChangeHandler change: (() -> Void)?) {
        refresher.tintColor = ThemeUtils.mainColor()
        refresher.rx.controlEvent(.valueChanged).subscribe(onNext: {
            change?()
        }).disposed(by: disposeBag)
        refresher.rx.controlEvent(.valueChanged).bind(to: event).disposed(by: disposeBag)
        tableView.addSubview(refresher)
    }
}

extension LoadMoreApplicable where Self: UIViewController {
    var isLoadingMore: Variable<Bool> {
        return associatedObject(base: self, key: &isLoadingHandle, initialiser: { () -> Variable<Bool> in
            return Variable<Bool>(false)
        })
    }

    var loadingIndicator: UIActivityIndicatorView {
        return associatedObject(base: self,
                                key: &loadingIndicatorHandle,
                                initialiser: { () -> UIActivityIndicatorView in
                                    return UIActivityIndicatorView()
        })
    }

    func loader(forTableView tableView: UITableView) {
        loadingIndicator.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 30.0)
        loadingIndicator.activityIndicatorViewStyle = .whiteLarge
        loadingIndicator.color = ThemeUtils.mainColor()
        loadingIndicator.hidesWhenStopped = true
        tableView.tableFooterView = loadingIndicator
    }

    func releaseLoader(inTableView tableView: UITableView) {
        tableView.tableFooterView = nil
    }

    func showLoader(inTableView tableView: UITableView) {
        if tableView.tableFooterView == nil {
            self.loader(forTableView: tableView)
        }
        loadingIndicator.startAnimating()
        isLoadingMore.value = true
    }

    func dismissLoader() {
        loadingIndicator.stopAnimating()
        isLoadingMore.value = false
    }

    func rx_tableView(forTableView tableView: UITableView,
                      withLoadingEvent loadingEvent: (() -> Void)?,
                      withDeceleratingEvent deceleratingEvent: (() -> Void)?) {
        isLoadingMore.asObservable().throttle(0.3, scheduler: MainScheduler.instance).distinctUntilChanged()
            .bind { loading in
                if loading {
                    loadingEvent?()
                }}.disposed(by: disposeBag)

        tableView.rx.didEndDecelerating.subscribe(onNext: {
            deceleratingEvent?()
        }).disposed(by: disposeBag)
    }
}
