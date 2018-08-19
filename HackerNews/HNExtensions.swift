//
//  HNExtensions.swift
//  HackerNews
//
//  Created by Muhammed Cavusoglu on 18.08.2018.
//  Copyright © 2018 Muhammed Cavusoglu. All rights reserved.
//

import SafariServices
import Foundation
import SwiftyJSON
import Alamofire
import UIKit

// MARK: UITableView

extension HNViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return submissions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "HNTableViewCell", for: indexPath) as? HNTableViewCell {
            cell.hnVC = self
            if submissions.count != 0 {
                cell.setData(s: submissions[indexPath.row])
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let s = submissions[indexPath.row]
        if let url = s.url {
            let safariVC = SFSafariViewController(url: URL(string: url)!)
            
            safariVC.delegate = self
            safariVC.preferredBarTintColor = UIColor(red:0.96, green:0.96, blue:0.94, alpha:1.0)
            safariVC.preferredControlTintColor = UIColor(red:1.00, green:0.40, blue:0.00, alpha:1.0)
            
            self.present(safariVC, animated: true, completion: nil)
        }
    }
    
    func configureTableView() {
        hnTableView.delegate = self
        hnTableView.dataSource = self
        hnTableView.register(UINib(nibName: "HNTableViewCell", bundle: nil), forCellReuseIdentifier: "HNTableViewCell")
        
        hnTableView.rowHeight = UITableViewAutomaticDimension
        hnTableView.estimatedRowHeight = 120
        
        hnTableView.addSubview(refreshControl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.retrieveTopStories()
    }
}

// MARK: SFSafariViewControllerDelegate

extension HNViewController: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension HNTableViewCell: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: API Calls

extension HNViewController {    
    func extractSubmissionPropertiesFromJSON(json: JSON) {
        let s = Submission(title: json["title"].string!, url: json["url"].string, by: json["by"].string!, score: json["score"].int!, descendants: json["descendants"].int, time: json["time"].int!, id: json["id"].int!)
        submissions.append(s)
    }
    
    func retrieveTopStories() {
        let baseURL = "https://hacker-news.firebaseio.com/v0/"
        let endpoint = baseURL + "topstories" + ".json"
        let submissionLimit = 30
        
        submissions = []
        
        Alamofire.request(endpoint).responseJSON { (response) in
            // print(response.request!)
            
            switch response.result {
            case .success:
                if let responseValue = response.result.value {
                    let responseValueJSON = JSON(responseValue)
                    
                    for i in 0...(submissionLimit - 1) {
                        let submissionEndpoint = baseURL + "item/" + String(responseValueJSON[i].int!) + ".json"
                        Alamofire.request(submissionEndpoint).responseJSON(completionHandler: { (submissionResponse) in
                            // print(submissionResponse.request!)
                            
                            switch submissionResponse.result {
                            case .success:
                                if let submissionResponseValue = submissionResponse.result.value {
                                    let submissionResponseValueJSON = JSON(submissionResponseValue)
                                    
                                    self.extractSubmissionPropertiesFromJSON(json: submissionResponseValueJSON)
                                    
                                    if self.submissions.count == submissionLimit {
                                        self.hnTableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                    }
                                }
                            case .failure(let submissionResponseError):
                                print(submissionResponseError)
                            }
                        })
                    }
                }
            case .failure(let responseError):
                print(responseError)
            }
        }
    }
}

// MARK: UITableViewCell

extension HNTableViewCell {
    func timeAgoSinceDate(timeStamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timeStamp)
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = NSDate()
        let earliest = now.earlierDate(date as Date)
        let latest = (earliest == now as Date) ? date : now as Date
        let components = calendar.dateComponents(unitFlags, from: earliest as Date,  to: latest as Date)
        
        if (components.year! >= 1) {
            return "\(components.year!)y"
        } else if (components.month! >= 1) {
            return "\(components.month!)mo"
        } else if (components.weekOfYear! >= 1) {
            return "\(components.weekOfYear!)w"
        } else if (components.day! >= 1) {
            return "\(components.day!)d"
        } else if (components.hour! >= 1) {
            return "\(components.hour!)h"
        } else if (components.minute! >= 1) {
            return "\(components.minute!)m"
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "now"
        }
    }
}
