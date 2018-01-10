//
//  LogUtil.swift
//  NewsApp
//
//  Created by Tran Minh Tung on 1/9/18.
//  Copyright © 2018 Tran Minh Tung. All rights reserved.
//

import Foundation
import SwiftyBeaver

let LOGGER = Logger()

class Logger {
    private let log = SwiftyBeaver.self
    private let console = ConsoleDestination()  // log to Xcode Console

    init() {
        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"
        // log.addDestination(console)
    }

    func verbose(_ message: Any) {
        log.verbose(message)
    }

    func info(_ message: Any) {
        log.info(message)
    }

    func debug(_ message: Any) {
        log.debug(message)
    }

    func warning(_ message: Any) {
        log.warning(message)
    }

    func error(_ message: Any) {
        log.error(message)
    }
}
