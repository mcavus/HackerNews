//
//  HNViewController.swift
//  HackerNews
//
//  Created by Muhammed Cavusoglu on 17.08.2018.
//  Copyright © 2018 Muhammed Cavusoglu. All rights reserved.
//

import UIKit
import Alamofire

class HNViewController: UIViewController {
    @IBOutlet weak var hnTableView: UITableView!
    
    var submissions: [Submission] = []
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:0.98, green:0.62, blue:0.27, alpha:1.0)
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.retrieveTopStories()
    }
}
