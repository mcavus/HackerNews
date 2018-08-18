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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hnTableView.delegate = self
        hnTableView.dataSource = self
        hnTableView.register(UINib(nibName: "HNTableViewCell", bundle: nil), forCellReuseIdentifier: "HNTableViewCell")
        
        Alamofire.request("https://hacker-news.firebaseio.com/v0/item/8863.json?print=pretty").responseJSON { (response) in
            print(response)
        }
    }
}

// MARK: UITableView

extension HNViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HNTableViewCell", for: indexPath) as? HNTableViewCell {
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
