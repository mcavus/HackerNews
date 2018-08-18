//
//  HNExtensions.swift
//  HackerNews
//
//  Created by Muhammed Cavusoglu on 18.08.2018.
//  Copyright © 2018 Muhammed Cavusoglu. All rights reserved.
//

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
            cell.setData(s: submissions[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

// MARK: API Calls

extension HNViewController {    
    func extractSubmissionPropertiesFromJSON(json: JSON) {
        let s = Submission(title: json["title"].string!, url: json["url"].string, by: json["by"].string!, score: json["score"].int!, descendants: json["descendants"].int, time: json["time"].int!)
        submissions.append(s)
        hnTableView.reloadData()
    }
    
    func retrieveTopStories() {
        let endpoint = baseURL + "topstories" + ".json"
        
        Alamofire.request(endpoint).responseJSON { (response) in
            // print(response.request!)
            
            switch response.result {
            case .success:
                if let responseValue = response.result.value {
                    let responseValueJSON = JSON(responseValue)
                    
                    for i in 0...self.submissionLimit {
                        let submissionEndpoint = self.baseURL + "item/" + String(responseValueJSON[i].int!) + ".json"
                        Alamofire.request(submissionEndpoint).responseJSON(completionHandler: { (submissionResponse) in
                            // print(submissionResponse.request!)
                            
                            switch submissionResponse.result {
                            case .success:
                                if let submissionResponseValue = submissionResponse.result.value {
                                    let submissionResponseValueJSON = JSON(submissionResponseValue)
                                    
                                    self.extractSubmissionPropertiesFromJSON(json: submissionResponseValueJSON)
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
