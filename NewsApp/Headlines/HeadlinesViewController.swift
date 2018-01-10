//
//  HeadlinesViewController.swift
//  NewsApp
//
//  Created by KApp Dev on 1/9/18.
//  Copyright © 2018 tungtm. All rights reserved.
//

import UIKit
import RxDataSources
import RxSwift
import Whisper

class HeadlinesViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    var detailViewController: DetailViewController? = nil

    fileprivate var viewModel = HeadlinesViewModel()
    fileprivate var disposeBag = DisposeBag()

    fileprivate var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }

        initTableView()
        bindToRx()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        doFirstRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension HeadlinesViewController: PullApplicable {
    fileprivate func configRefreshControl() {
        // config pull to refresh control
        rx_refresher(forTableView: tableView, withControlEvent: viewModel.requestPull) { [weak self] _ in
            self?.viewModel.next.value = 1
            self?.tableView.hideEmpty()
        }

        // setup internet observation
        // with the case internet for pulling to refresh, already defined in parent view controller (KOLViewController)
        viewModel.internetStatus.value = ConnectionStatus.isInternetAvailable()
        viewModel.internet.subscribe(onNext: { isAvailable in
            if !isAvailable {
//                UIUtils.showError(message: Localizer.no_internet.description)
                
            }
        }).disposed(by: disposeBag)

        // setup indicator
        viewModel.internet.bind(to: refresher.rx.isRefreshing).disposed(by: disposeBag)
        viewModel.requestingPull.bind(to: refresher.rx.isRefreshing).disposed(by: disposeBag)

        viewModel.requestingPull.subscribe(onNext: { executing in
//            UIUtils.showIndicator(executing: executing, withProgress: false)
        }, onDisposed: {
//            UIUtils.showIndicator(executing: false, withProgress: false)
        }).disposed(by: disposeBag)
    }
}

extension HeadlinesViewController: InternetObservable {
    fileprivate func rx_internet() {
        self.internetStatus(whenConnected: { [weak self] in
            self?.viewModel.internetStatus.value = true
        }) { [weak self] in
            self?.viewModel.internetStatus.value = false
        }
    }
}

extension HeadlinesViewController {
    fileprivate func doFirstRequest() {
        if self.firstTime {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
                self?.firstTime = false
                self?.tableView.setContentOffset(CGPoint(x: 0, y: -(self?.refresher.frame.size.height)! - 20),
                                                 animated: true)
                self?.refresher.sendActions(for: .valueChanged)
            }
        }
    }

    fileprivate func initTableView() {
        tableView.register(UINib(nibName: String(describing: ArticleItemCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: ArticleItemCell.self))
        tableView.empty(message: "No Articles Found")
    }

    fileprivate func bindToRx() {
        rx_internet()
        configRefreshControl()

        // setup internet observation
        viewModel.internetStatus.value = ConnectionStatus.isInternetAvailable()
        viewModel.internet.subscribe(onNext: { isAvailable in
            if !isAvailable {
//                UIUtils.showError(message: Localizer.no_internet.description)
            }
        }).disposed(by: disposeBag)

        // setup table datasource
        let items = viewModel.itemsObs
        items.bind(to: tableView.rx.items(cellIdentifier: "ArticleItemCell", cellType: ArticleItemCell.self))
        {(_, element, cell) in
            cell.articleModel = element
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            guard let item = self?.viewModel.item(at: indexPath.row) else {
                LOGGER.error("HeadlinesViewController - bindToRx - itemSelected: cannot select this item")
                return
            }
            
            if let split = self?.splitViewController {
                let controllers = split.viewControllers
                let detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
                detailViewController?.detailItem = item.url
                detailViewController?.navigationItem.leftBarButtonItem = split.displayModeButtonItem
                detailViewController?.navigationItem.leftItemsSupplementBackButton = true
            }
        }).disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        viewModel.pullFinished.subscribe(onNext: {[weak self] result in
            self?.showResult(result: result, message: "tungtm === successfully reload Trial items")
        }).disposed(by: disposeBag)
    }

    fileprivate func showResult(result: FeedResult, message: String) {
        switch result {
        case .success(let response):
            if response.status == "ok" {
                LOGGER.debug(message)
                
                if viewModel.items.value.count > 0 {
                    tableView.hideEmpty()
                } else {
                    tableView.showEmpty()
                }
                
            } else {
                tableView.hideEmpty()
//                UIUtils.showError(message: response.message)
            }
            
        case .failure(let errorMsg), .unauthorized(let errorMsg):
            tableView.hideEmpty()
//            UIUtils.showError(message: errorMsg)
        }
    }
}

extension HeadlinesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

