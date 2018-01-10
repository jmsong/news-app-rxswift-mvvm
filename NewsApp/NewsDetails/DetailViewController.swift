//
//  DetailViewController.swift
//  NewsApp
//
//  Created by KApp Dev on 1/9/18.
//  Copyright © 2018 tungtm. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let unwrapUrl = url {
            if let label = detailDescriptionLabel {
                label.text = unwrapUrl.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var url: String? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

