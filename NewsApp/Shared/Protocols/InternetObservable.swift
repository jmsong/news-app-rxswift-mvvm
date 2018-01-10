//
//  InternetObservable.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import ReachabilitySwift
import RxReachability
import RxSwift
import UIKit

protocol InternetObservable {
}

let disposeBag = DisposeBag()
extension InternetObservable where Self: UIViewController {
    func internetStatus(whenConnected connected: (() -> Void)?,
                        whenDisconnected disconnected: (() -> Void)?) {

        Reachability.rx.isConnected
            .subscribe(onNext: {
                LOGGER.debug("Is connected")
                connected?()
            })
            .disposed(by: disposeBag)

        Reachability.rx.isDisconnected
            .subscribe(onNext: {
                LOGGER.warning("Is disconnected")
                disconnected?()
            })
            .disposed(by: disposeBag)
    }
}
