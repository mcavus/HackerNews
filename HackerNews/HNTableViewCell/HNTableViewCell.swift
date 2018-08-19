//
//  HNTableViewCell.swift
//  HackerNews
//
//  Created by Muhammed Cavusoglu on 18.08.2018.
//  Copyright © 2018 Muhammed Cavusoglu. All rights reserved.
//

import SafariServices
import UIKit

class HNTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var pointsAndByLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
    @IBOutlet weak var viewCommentsButton: UIButton!
    
    var hnVC = HNViewController()
    var submissionID = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(s: Submission) {
        submissionID = s.id
        
        titleLabel.text = s.title
        urlLabel.text = s.url
        pointsAndByLabel.text = String(s.score) + " points by " + s.by
        timeLabel.text = self.timeAgoSinceDate(timeStamp: Double(s.time))
        
        if let dCount = s.descendants {
            commentCountButton.setTitle(String(dCount), for: .normal)
        } else {
            commentCountButton.setTitle("0", for: .normal)
        }
    }
    
    @IBAction func viewComments(_ sender: Any) {
        let commentURL = URL(string: "https://news.ycombinator.com/item?id=" + String(submissionID))!
        let safariVC = SFSafariViewController(url: commentURL)
        
        safariVC.delegate = self
        safariVC.preferredBarTintColor = UIColor(red:0.96, green:0.96, blue:0.94, alpha:1.0)
        safariVC.preferredControlTintColor = UIColor(red:1.00, green:0.40, blue:0.00, alpha:1.0)
        
        hnVC.present(safariVC, animated: true, completion: nil)
    }
}
