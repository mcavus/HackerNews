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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureTableView()
        self.retrieveTopStories()
    }
}
