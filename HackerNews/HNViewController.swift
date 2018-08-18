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
    
    let baseURL: String = "https://hacker-news.firebaseio.com/v0/"
    let submissionLimit: Int = 29
    var submissions: [Submission] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hnTableView.delegate = self
        hnTableView.dataSource = self
        hnTableView.register(UINib(nibName: "HNTableViewCell", bundle: nil), forCellReuseIdentifier: "HNTableViewCell")
        
        self.retrieveTopStories()
    }
}
