//
//  LaunchViewController.swift
//  KApp
//
//  Created by KApp Dev on 5/30/17.
//  Copyright © 2017 Larvol. All rights reserved.
//

import UIKit
import RxSwift
import RxWebKit
import SnapKit
import WebKit
import TLYShyNavBar
import Whisper

class NewsDetailViewController: UIViewController {
    private var webView: WKWebView = WKWebView()
    private var progressView: UIProgressView = UIProgressView(progressViewStyle: .bar)

    private let disposeBag = DisposeBag()

    var newsUrl: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        initWebview()
        self.shyNavBarManager.scrollView = self.webView.scrollView
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startLoading()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopLoading()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    deinit {
        LOGGER.debug("NewsDetailViewController --- deinit")
    }

    private func initWebview() {
        self.view?.addSubview(webView)

        let progressView = self.progressView

        webView.snp.makeConstraints { [unowned self] make in
            let parent = self.view
            make.center.equalTo((parent?.snp.center)!)
            make.width.equalTo((parent?.snp.width)!)
            make.top.equalTo((parent?.snp.top)!)
            make.bottom.equalTo((parent?.snp.bottom)!)
        }

        webView.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.top).offset(64)
            make.leading.equalTo(webView.snp.leading)
            make.trailing.equalTo(webView.snp.trailing)
        }

        webView.rx.url.shareReplay(1)
            .subscribe(onNext: {
                LOGGER.debug("URL: \(String(describing: $0))")
            })
            .addDisposableTo(disposeBag)

        webView.rx.loading.shareReplay(1)
            .subscribe(onNext: {
                LOGGER.debug("loading: \($0)")
                progressView.isHidden = !$0
                UIApplication.shared.isNetworkActivityIndicatorVisible = $0
            })
            .addDisposableTo(disposeBag)

        webView.rx.estimatedProgress.shareReplay(1)
            .subscribe(onNext: { progress in
                LOGGER.debug("estimatedProgress: \(progress)")
                progressView.progress = Float(progress)
            })
            .addDisposableTo(disposeBag)

        webView.rx.deallocating.shareReplay(1)
            .subscribe(onNext: {
                LOGGER.warning("tungtm === deallocating!!!!!!!!!")
            })
            .addDisposableTo(disposeBag)

        webView.navigationDelegate = self
    }

    private func initRequest() {
        guard let url = URL(string: newsUrl ?? "") else {
            UIUtils.showError(message: Localizer.invalid_url.description)
            return
        }

        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func startLoading() {
        initRequest()
        if ConnectionStatus.isInternetAvailable() {
        } else {
            UIUtils.showError(message: Localizer.no_internet.description)
        }
    }

    private func stopLoading() {
        if webView.isLoading {
            webView.stopLoading()
        }
    }

    @objc private func reload() {
        if ConnectionStatus.isInternetAvailable() {
            if webView.isLoading {
                webView.reload()
            } else {
                initRequest()
            }
        } else {
            UIUtils.showError(message: Localizer.no_internet.description)
        }
    }
}

extension NewsDetailViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        let nsError = error as NSError
        if nsError.code == -999 {
            return
        }

        UIUtils.showError(message: error.localizedDescription)
    }
}
